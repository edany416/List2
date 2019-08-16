//
//  TodoListViewController.swift
//  List2
//
//  Created by edan yachdav on 6/12/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class TodoListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tagPicker: UICollectionView!
    @IBOutlet weak var addButton: RoundedButton!
    
    private var tasks:[Task]? = [Task]() {
        didSet {
            if tableView != nil {
                self.tableView.reloadData()
            }
            tasks!.sort()
        }
    }
    
    private var isTagEdited = false
    private var allTags:[Tag]? = [Tag]() {
        didSet {
            if tagPicker != nil {
                self.tagPicker.reloadData()
            }
        }
    }
    //private var tapTracker: [Tag:Bool]?
    private var tapTracker: TapTracker!
    private var filter: TaskFilter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tagPicker.delegate = self
        tagPicker.dataSource = self
        tagPicker.register(UINib.init(nibName: "TagFilterCell", bundle: nil), forCellWithReuseIdentifier: "TagFilterCell")
        
        retrieveData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didCompleteTodo(_:)), name: .didCompleteTodo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
        addButton.outlineColor = .clear

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        popUpBackground.removeFromSuperview()
    }
    
    @objc func contextDidSave(_ notification: Notification) {
        print("Did Save")
        retrieveData()
    }
    
    private func retrieveData() {
        tasks = PersistanceService.instance.fetchTasks(given: Task.fetchRequest())
        allTags = PersistanceService.instance.fetchTags(given: Tag.fetchRequest())
        allTags = allTags!.filter{$0.tasks!.count != 0}
        tapTracker = TapTracker(tags: allTags!)
        filter = TaskFilter(defaultTags: Set(allTags!))
    }
    
    @objc func didCompleteTodo(_ notification: Notification) {
        let cellRow = notification.userInfo!["rowForCell"] as! Int
        let task = tasks![cellRow]
        PersistanceService.instance.completeTask(task)
    }
    
    private var popUpBackground: UIView!
    @IBAction func onTapAdd(_ sender: RoundedButton) {
        popUpBackground = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissAddPopUp))
        popUpBackground.addGestureRecognizer(tapGesture)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = popUpBackground.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popUpBackground.addSubview(blurEffectView)
        
        let popUpView = AddPopUpView(frame: CGRect(x: 0, y: 0, width: popUpBackground.bounds.width * 0.60, height: 100))
        popUpView.center = popUpBackground.center
        popUpView.delegate = self
        
        popUpBackground.addSubview(popUpView)
        popUpBackground.alpha = 0
        
        self.view.addSubview(popUpBackground)
        
        UIView.animate(withDuration: 0.1) {
            self.popUpBackground.alpha = 1
        }
    }
    
    @objc private func dismissAddPopUp() {
        UIView.animate(withDuration: 0.1, animations: {
            self.popUpBackground.alpha = 0
        }) { (finished) in
            self.popUpBackground.removeFromSuperview()
        }
        
    }
    
}

//MARK: - TABLEVIEW DELEGATE
extension TodoListViewController: UITableViewDelegate, UITableViewDataSource, ExpandingCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Todo Cell", for: indexPath) as! ExpandingTableViewCell
        let task = tasks![indexPath.row]
        cell.taskName.text = task.name
        cell.row = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func didTapCell() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

//MARK: - COLLECTION VIEW DELEGATE
extension TodoListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if allTags!.count == 0 {
            return 0
        }
        return allTags!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tagPicker.dequeueReusableCell(withReuseIdentifier: "TagFilterCell", for: indexPath) as! TagCell
        let tag = allTags![indexPath.row]
        let isCellTapped = tapTracker.tapStatus(for: tag)
        cell.title.text = tag.name
        if isCellTapped {
            cell.tapped = true
        } else {
            cell.tapped = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = collectionView.cellForItem(at: indexPath) as? TagCell{
            let tag = allTags![indexPath.row]
            
            tapTracker.setTappedStatus(for: tag)
            
            allTags = filter?.tagList(for: tag)
            tasks = filter?.filterTasksForTag(tag: tag)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = allTags![indexPath.row]
        let tagName = tag.name! as NSString
        let sizeOfTagName = tagName.size(withAttributes: [.font: UIFont.systemFont(ofSize: 20)])
        let size = CGSize(width: sizeOfTagName.width, height: tagPicker.frame.height)
        return size
    }
}

// MARK - ADD POP UP DELEGATE
extension TodoListViewController: AddPopUpDelegate {
    func didTapNewTask(_ popUpView: AddPopUpView) {
        popUpView.delegate = nil
        performSegue(withIdentifier: "TaskDetailModal", sender: nil)
    }
    
    func didTapNewTag(_ popUpView: AddPopUpView) {
        popUpView.delegate = nil
        performSegue(withIdentifier: "AddTagModal", sender: nil)
    }
}
