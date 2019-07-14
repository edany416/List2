//
//  PersistenceService.swift
//  List2
//
//  Created by edan yachdav on 7/12/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import Foundation
import CoreData
import os

class PersistanceService {
    
    static let instance = PersistanceService()
    
    private init() { }
    
    
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "List2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = PersistanceService.instance.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveTask(taskName name: String, dueDate date: Date?, notes: String?) {
        let newTask = Task(context: self.context)
        newTask.name = name
        if let dueDate = date {
            newTask.dueDate = dueDate as NSDate
        }
        newTask.notes = notes
        PersistanceService.instance.saveContext()
        os_log("Task successfully saved", log: OSLog.default, type: .info)
    }
    
    func fetchTasks(given fetchRequest: NSFetchRequest<Task>) -> [Task]? {
        var tasks: [Task]?
        do {
            tasks = try PersistanceService.instance.context.fetch(fetchRequest)
        } catch {
            os_log("Could not fetch task", log: .default, type: .error)
        }
        return tasks ?? nil
    }
}
