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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        CoreDataTester.printData()
    }
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Todo Cell", for: indexPath) as! ExpandingTableViewCell
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

private class CoreDataTester {
    
    static func printData() {
        let tasks = PersistanceService.instance.fetchTasks(given: Task.fetchRequest())
        if tasks != nil {
            for task in tasks! {
                print("Name \(task.name!) - Due date \(task.dueDate) - Notes: \(task.notes)")
                for tag in task.tags! {
                    if let tag = tag as? Tag {
                        print("Tag - \(tag.name!)")
                    }
                }
            }
        }
        
        print("----------------------------")
        
        let tags = PersistanceService.instance.fetchTags(given: Tag.fetchRequest())
        if tags != nil {
            for tag in tags! {
                print("Tag name - \(tag.name!)")
                for task in tag.tasks! {
                    if let task =  task as? Task {
                        print("Task - \(task.name!)")
                    }
                }
            }
        }
    }
}
