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
    func removeTask(at index: Int)
}

class TaskListPresenter {
    private var tasks: [Task]!
    private var indexOfCompletedTask: Int?
    var taskTableViewDataSource: TaskTableViewDataSource!
    
    weak var delegate: TaskListPresenterDelegate? {
        didSet {
            delegate!.updateTaskList(tasks.map({$0.taskName!}))
        }
    }
    
    init() {
        loadData()
        //NotificationCenter.default.addObserver(self, selector: #selector(modelUpdated), name: .NSManagedObjectContextDidSave, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(modelUpdated), name: .DidCreateNewTaskNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(modelUpdated), name: .DidEditTaskNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTaskCompletion), name: .DidDeleteTaskNotification, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(tagsChangedListener(_:)), name: .TagsChagnedNotification, object: nil)
        
    }
    
    func task(at index: Int) -> Task {
        return taskTableViewDataSource.tasks[index]
    }
    
    func completeTask(at index: Int) {
        indexOfCompletedTask = index
        let task = tasks[indexOfCompletedTask!]
        PersistanceServices.instance.deleteTask(taskId: task.id!)
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
    
    @objc private func handleTaskCompletion() {
        loadData()
        taskTableViewDataSource.updateTaskList(tasks)
        delegate?.removeTask(at: indexOfCompletedTask!)
        indexOfCompletedTask = nil
    }
    
    //Update tasks based on selected tags
    @objc private func tagsChangedListener(_ notification: NSNotification) {
        if let tasks = notification.userInfo?["Tasks"] as? [Task] {
            self.tasks = tasks
            taskTableViewDataSource.updateTaskList(tasks)
            delegate?.updateTaskList(self.tasks.map({$0.taskName!}))
        }
    }
}

