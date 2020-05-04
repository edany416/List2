//
//  TaskListPresenter.swift
//  ListIII
//
//  Created by Edan on 5/3/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation

protocol TaskListPresenterDelegate: class {
    func updateTaskList(_ tasks: [String])
}

class TaskListPresenter {
    private var tasks: [Task]!
    var taskTableViewDataSource: TaskTableViewDataSource!
    
    weak var delegate: TaskListPresenterDelegate? {
        didSet {
            delegate!.updateTaskList(tasks.map({$0.taskName!}))
        }
    }
    
    init() {
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(modelUpdated), name: .NSManagedObjectContextDidSave, object: nil)
    }
    
    private func loadData() {
        tasks = PersistanceManager.instance.fetchTasks()
        if taskTableViewDataSource == nil {
            taskTableViewDataSource = TaskTableViewDataSource(fromTasks: tasks)
        }
    }
    
    @objc private func modelUpdated() {
        loadData()
        taskTableViewDataSource.updateTaskList(tasks)
        delegate?.updateTaskList(tasks.map({$0.taskName!}))
    }
}

