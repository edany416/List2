//
//  TaskTableViewDataSource.swift
//  ListIII
//
//  Created by Edan on 3/8/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation
import UIKit

class TaskTableViewDataSource: NSObject, UITableViewDataSource {
    private(set) var tasks: [Task]!
    
    init(fromTasks tasks: [Task]) {
        super.init()
        self.tasks = tasks
    }
    
    func updateTaskList(_ tasks: [Task]) {
        self.tasks = tasks
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        let task = tasks[indexPath.row]
        cell.configureCell(from: TaskCellModel(taskLabelText: task.taskName!))
        return cell
    }
}
