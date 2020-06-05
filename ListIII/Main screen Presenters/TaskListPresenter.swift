//
//  TaskListPresenter.swift
//  ListIII
//
//  Created by Edan on 6/2/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation
import UIKit

protocol TaskListPresenterDelegate: class {
    func didSelectTask(_ task: Task)
}

class TaskListPresenter: NSObject {
    private(set) var tasks: [Task]!
    weak var delegate: TaskListPresenterDelegate?
    
    init(fromTasks tasks: [Task]) {
        self.tasks = tasks.sorted(by: {$0.taskName! < $1.taskName!})
    }
    
    func update(tasks: [Task]) {
        self.tasks = tasks.sorted(by: {$0.taskName! < $1.taskName!})
    }
    
    func removeTask(atIndex index: Int) {
        tasks.remove(at: index)
    }
}

extension TaskListPresenter: UITableViewDataSource {
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

extension TaskListPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectTask(tasks[indexPath.row])
    }
}




