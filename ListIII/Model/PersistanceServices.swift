//
//  PersistanceServices.swift
//  ListIII
//
//  Created by Edan on 5/13/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation

class PersistanceServices {
    
    static let instance = PersistanceServices()
    
    private enum PersistanceOperation {
        case newTask
        case editedTask
        case deletedTask
    }
    
    private var operation: PersistanceOperation?
    
    //Make another local variable so that this only fetched tags if they have no been fetched initially or the tags have been changed
    var tags: [Tag] {
        return PersistanceManager.instance.fetchTags()
    }
    
    var tasks: [Task] {
        return PersistanceManager.instance.fetchTasks()
    }
    
    private init(){
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave), name: .NSManagedObjectContextDidSave, object: nil)
    }
    
    @objc private func contextDidSave() {
        if operation != nil {
            switch operation! {
            case .newTask:
                NotificationCenter.default.post(name: .DidCreateNewTaskNotification, object: nil, userInfo: nil)
            case .deletedTask:
                NotificationCenter.default.post(name: .DidDeleteTaskNotification, object: nil, userInfo: nil)
            case .editedTask:
                NotificationCenter.default.post(name: .DidEditTaskNotification, object: nil, userInfo: nil)
            }
        }
        operation = nil
    }
    
    func saveNewTask(_ taskName: String, _ associatedTags: [String]) {
        operation = .newTask
        PersistanceManager.instance.createNewTask(taskName, associatedTags: associatedTags)
    }
    
    func editTask(withId id: String, taskName: String, associatedTags: [String]) {
        operation = .editedTask
        PersistanceManager.instance.updateTask(withId: id, taskName, associatedTags: associatedTags)
    }
    
    func deleteTask(taskId: String) {
        operation = .deletedTask
        let task = PersistanceManager.instance.fetchTask(withId: taskId)
        PersistanceManager.instance.deleteTask(task!)
    }
    
    func tagExists(_ tagName: String) -> Bool {
        return PersistanceManager.instance.fetchTag(named: tagName) != nil
    }
}

extension Notification.Name {
    static let DidCreateNewTaskNotification = Notification.Name("DidCreateNewTaskNotification.edanyachdav")
    static let DidEditTaskNotification = Notification.Name("DidEditTaskNotification.edanyachdav")
    static let DidDeleteTaskNotification = Notification.Name("DidDeleteTaskNotification.edanyachdav")
}
