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
    
    private var allTags:[Tag]? = [Tag]() {
        didSet {
            if tagPicker != nil {
                self.tagPicker.reloadData()
            }
            allTags!.sort()
        }
    }
    
    private var filter: TaskFilter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tagPicker.delegate = self
        tagPicker.dataSource = self
        tagPicker.register(UINib.init(nibName: "TagFilterCell", bundle: nil), forCellWithReuseIdentifier: "TagFilterCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //Only do this shit if some changes where made to the database
        tasks = PersistanceService.instance.fetchTasks(given: Task.fetchRequest())
        allTags = PersistanceService.instance.fetchTags(given: Tag.fetchRequest())
        filter = TaskFilter(defaultTags: Set(allTags!))
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
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) as? ExpandingTableViewCell {
//            if cell.isExpanded {
//                cell.contract()
//            } else {
//                cell.expand()
//            }
//            tableView.beginUpdates()
//            tableView.endUpdates()
//        }
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
        let cell = tagPicker.dequeueReusableCell(withReuseIdentifier: "TagFilterCell", for: indexPath) as! TagFilterCell
        let tag = allTags![indexPath.row]
        cell.title.text = tag.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TagFilterCell{
            let tag = allTags![indexPath.row]
            tasks = filter?.filterTasksForTag(tag: tag)
            cell.tapped = !cell.tapped
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = allTags![indexPath.row]
        let tagName = tag.name! as NSString
        let sizeOfTagName = tagName.size(withAttributes: [.font: UIFont.systemFont(ofSize: 17)])
        let size = CGSize(width: sizeOfTagName.width + 10, height: tagPicker.frame.height)
        return size
    }
}
