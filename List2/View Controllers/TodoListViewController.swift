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

    }
    
    @objc func contextDidSave(_ notification: Notification) {
        print("Did Save")
        retrieveData()
    }
    
    private func retrieveData() {
        tasks = PersistanceService.instance.fetchTasks(given: Task.fetchRequest())
        allTags = PersistanceService.instance.fetchTags(given: Tag.fetchRequest())
        tapTracker = TapTracker(tags: allTags!)
        filter = TaskFilter(defaultTags: Set(allTags!))
    }
    
    @objc func didCompleteTodo(_ notification: Notification) {
        let cellRow = notification.userInfo!["rowForCell"] as! Int
        let task = tasks![cellRow]
        PersistanceService.instance.completeTask(task)
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
        let size = CGSize(width: sizeOfTagName.width + 15, height: tagPicker.frame.height)
        return size
    }
}
