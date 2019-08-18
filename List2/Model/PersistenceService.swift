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
    
    
    //Manage context
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
    
    func saveTag(tagName name: String) {
        if let tag = PersistanceService.instance.fetchTag(for: Tag.fetchRequest(), named: name) {
            if tag.isSaved {
                NotificationCenter.default.post(name: .didAddDuplicateTag, object: nil)
            } else {
                tag.isSaved = true
                PersistanceService.instance.saveContext()
            }
        } else {
            let newTag = Tag(context: PersistanceService.instance.context)
            newTag.name = name
            newTag.isSaved = true
            PersistanceService.instance.saveContext()
        }
    }
    
    func saveTask(taskName name: String, dueDate date: Date?, notes: String?, tags: [String]?) {
        
        if PersistanceService.instance.fetchTask(for: Task.fetchRequest(), named: name) != nil {
            NotificationCenter.default.post(name: .didAddDuplicateTask, object: nil)
        } else {
            let newTask = Task(context: self.context)
            newTask.name = name
            if let dueDate = date {
                newTask.dueDate = dueDate as NSDate
            }
            newTask.notes = notes
            if tags != nil {
                //Associate tags with tasks
                for tag_string in tags! {
                    if let existingTag = fetchTag(for: Tag.fetchRequest(), named: tag_string) {
                        existingTag.addToTasks(newTask)
                    } else {
                        let newTag = Tag(context: PersistanceService.instance.context)
                        print("Saved \(newTag.isSaved)")
                        newTag.name = tag_string
                        newTask.addToTags(newTag)
                    }
                }
                
                //Associate tags with tags
                for i in 0..<tags!.count - 1 {
                    let currentTag = fetchTag(for: Tag.fetchRequest(), named: tags![i])
                    for j in i+1..<tags!.count {
                        let nextTag = fetchTag(for: Tag.fetchRequest(), named: tags![j])
                        currentTag!.addToAssociatedTags(nextTag!)
                    }
                }
            }
            PersistanceService.instance.saveContext()
            os_log("Task successfully saved", log: OSLog.default, type: .info)
        }
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
    
    func fetchTags(given fetchRequest: NSFetchRequest<Tag>) -> [Tag]? {
        var tags: [Tag]?
        do {
            tags = try PersistanceService.instance.context.fetch(fetchRequest)
        } catch {
            os_log("Could not fetch task", log: .default, type: .error)
        }
        return tags ?? nil
    }
    
    func fetchTag(for fetchRequest: NSFetchRequest<Tag>, named name: String) -> Tag? {
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        var tag: [Tag]?
        do {
            tag = try PersistanceService.instance.context.fetch(fetchRequest)
        } catch {
            os_log("Could not fetch tag", log: .default, type: .error)
        }
        
        if tag!.count == 0 {
            return nil
        }
        return tag![0]
    }
    
    func fetchTask(for fetchRequest: NSFetchRequest<Task>, named name: String) -> Task? {
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        var task: [Task]?
        do {
            task = try PersistanceService.instance.context.fetch(fetchRequest)
        } catch {
            os_log("Could not fetch tag", log: .default, type: .error)
        }
        
        if task!.count == 0 {
            return nil
        }
        return task![0]
    }
    
    func completeTask(_ task: Task) {
        let tagsForTask = (task.tags as! NSSet).allObjects as! [Tag]
        for tag in tagsForTask {
            tag.removeFromTasks(task)
            if !tag.isSaved && tag.tasks!.count == 0 {
                context.delete(tag)
            }
        }
        context.delete(task)
        PersistanceService.instance.saveContext()
    }
    
    func removeSavedTag(_ tag: Tag) {
        if tag.tasks!.count > 0 {
            for task in tag.tasks!.allObjects as! [Task] {
                if task.tags!.count == 1 {
                    if let unTagged = PersistanceService.instance.fetchTag(for: Tag.fetchRequest(), named: "Untagged") {
                        unTagged.addToTasks(task)
                    } else {
                        let unTagged = Tag(context: PersistanceService.instance.context)
                        unTagged.name = "Untagged"
                        unTagged.addToTasks(task)
                    }
                }
            }
        }
        
        context.delete(tag)
        PersistanceService.instance.saveContext()
    }
}
