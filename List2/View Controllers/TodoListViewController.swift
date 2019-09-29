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
    @IBOutlet weak var addButton: RoundedButton!
    @IBOutlet weak var tagPickerCollectionView: UICollectionView!
    @IBOutlet weak var selectedTagsCollectionView: UICollectionView!
    
    
    
    private var tasks:[Task]? = [Task]() {
        didSet {
            if tableView != nil {
                self.tableView.reloadData()
            }
            tasks!.sort()
        }
    }
    
    private var runningTagsManager: TagPickerCollectionViewManager!
    private var selectedTagsManager: SelectedTagsCollectionViewManager!
    
    private var isTagEdited = false
    private var tags:[Tag]? = [Tag]()
    //private var tapTracker: [Tag:Bool]?
    //private var tapTracker: TapTracker!
    private var filter: TaskFilter?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        retrieveData()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didCompleteTodo(_:)),
                                               name: .didCompleteTodo,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(contextDidSave(_:)),
                                               name: Notification.Name.NSManagedObjectContextDidSave,
                                               object: nil)
        
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
        tags = PersistanceService.instance.fetchTags(given: Tag.fetchRequest())
        tags = tags!.filter{$0.tasks!.count != 0}
        runningTagsManager = TagPickerCollectionViewManager(collectionView: tagPickerCollectionView, data: tags!)
        filter = TaskFilter(defaultTags: Set(tags!))
        runningTagsManager.delegate = self
        selectedTagsManager = SelectedTagsCollectionViewManager(collectionView: selectedTagsCollectionView)
        
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
    
    private var tagsViewIsExpanded = false
    @IBOutlet weak var tagCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBAction func onTapSort(_ sender: Any) {
        if tagsViewIsExpanded {
            tagCollectionViewHeightConstraint.constant = 0
        } else {
            tagCollectionViewHeightConstraint.constant = 100
        }
        tagsViewIsExpanded = !tagsViewIsExpanded
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
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

// MARK - TAG PICKER DELEGATE
extension TodoListViewController: TagPickerCollectionViewDelegate {
    func didTapCellForTag(tag: Tag, selected: Bool) {
        selectedTagsManager.updateWithTag(tag: tag, removing: !selected)
        tasks = filter?.filterTasksForTag(tag: tag)
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
