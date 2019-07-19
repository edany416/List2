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
        }
    }
    
    private var tags:[Tag]? = [Tag]() {
        didSet {
            if tagPicker != nil {
                self.tagPicker.reloadData()
            }
        }
    }
    
    private var tagFilterManager = TagFilterManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tagPicker.delegate = self
        tagPicker.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tasks = PersistanceService.instance.fetchTasks(given: Task.fetchRequest())
        tags = PersistanceService.instance.fetchTags(given: Tag.fetchRequest())
    }
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TaskCell
        let task = tasks![indexPath.row]
        cell.taskName.text = task.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ExpandingTableViewCell {
            if cell.isExpanded {
                cell.contract()
            } else {
                cell.expand()
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}

extension TodoListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if tags!.count == 0 {
            return 0
        }
        return tags!.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tagPicker.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        
        if indexPath.row == 0 {
            cell.tagLabel.text = "All"
        } else {
            let tag = tags![indexPath.row - 1]
            cell.tagLabel.text = tag.name
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Filter stating point here
        let tagCell = tagPicker.cellForItem(at: indexPath) as! TagCell
        if tagCell.tagLabel.text == "All" {
            tasks = PersistanceService.instance.fetchTasks(given: Task.fetchRequest())
        } else {
            let filteredTasks = tagFilterManager.filter(tagCell.tagLabel.text!)
            tasks = Array(filteredTasks)
        }
        
        tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tagName: String?
        
        if indexPath.row == 0 {
            tagName = "all"
        } else {
            tagName = tags![indexPath.row-1].name
        }
        
        var size: CGSize = tagName!.size(withAttributes: [.font: UIFont.systemFont(ofSize: 17)])
        return size
    }
}
