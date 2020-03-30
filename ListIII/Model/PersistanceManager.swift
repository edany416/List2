//
//  PersistanceManager.swift
//  ListIII
//
//  Created by Edan on 2/26/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation
import CoreData
import os

class PersistanceManager {
    
    static let instance = PersistanceManager()
    
    private init() { }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ListIII")
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

    func saveContext () {
        let context = persistentContainer.viewContext
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
    
    func createNewTask(_ name: String, associatedTags: [String]) {
        let newTask = Task(context: PersistanceManager.instance.context)
        newTask.taskName = name
        newTask.id = UUID().uuidString
        
        for tagName in associatedTags {
            PersistanceManager.instance.createTag(named: tagName)
            let tag = PersistanceManager.instance.fetchTag(named: tagName)!
            newTask.addToTags(tag)
        }
        PersistanceManager.instance.saveContext()
    }
    
    func createTag(named name: String) -> Bool {
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let exists = try !(PersistanceManager.instance.context.fetch(fetchRequest).isEmpty)
            if exists {
                os_log("Tag with given ID already exists", log: .default, type: .error)
                return false
            }
            
        } catch {
            os_log("Error when checking if tag with given ID exists", log: .default, type: .error)
            return false
        }
        
        let newTag = Tag(context: PersistanceManager.instance.context)
        newTag.name = name
        PersistanceManager.instance.saveContext()
        return true
    }
    
    func fetchTasks() -> [Task] {
        var tasks = [Task]()
        do {
            if let fetchedTasks = try PersistanceManager.instance.context.fetch(Task.fetchRequest()) as? [Task] {
                tasks = fetchedTasks
            }
        } catch {
            os_log("Error when fetching tasks", log: .default, type: .error)
        }
        return tasks
    }
    
    func fetchTags() -> [Tag] {
        var tags = [Tag]()
        do {
            if let fetchedTags = try PersistanceManager.instance.context.fetch(Tag.fetchRequest()) as? [Tag] {
                tags = fetchedTags
            }
        } catch {
            os_log("Error when fetching tags", log: .default, type: .error)
        }
        
        return tags
    }
    
    func fetchTag(named name: String) -> Tag? {
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        var tag: Tag?
        
        do {
            let fetchedTag = try PersistanceManager.instance.context.fetch(fetchRequest)
            if !fetchedTag.isEmpty {
                tag = fetchedTag[0]
            }
        } catch {
            os_log("Error when fetching tag", log: .default, type: .error)
        }
        
        return tag
    }
    
    func fetchTask(withId taskId: String) -> Task?{
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", taskId)
        
        var task: Task?
        
        do {
            let fetchedTask = try PersistanceManager.instance.context.fetch(fetchRequest)
            if !fetchedTask.isEmpty {
                task = fetchedTask[0]
            }
        } catch {
            os_log("Error when fetching task", log: .default, type: .error)
        }
        
        return task
    }
    
    func allTags(for tasks: [Task]) -> [Tag] {
        var ids = [String]()
        for task in tasks {
            ids.append(task.id!)
        }
        
        var predicates = [NSPredicate]()
        for id in ids {
            let predicate = NSPredicate(format: "ANY tasks.id == %@", id)
            predicates.append(predicate)
        }
        
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        let tags = [Tag]()
        do {
            let tags = try PersistanceManager.instance.context.fetch(fetchRequest)
            return tags
            
        } catch {
            os_log("Error when fetching tag", log: .default, type: .error)
        }
        
        return tags
    }
    
    func fetchTasks(for tags: [Tag]) -> [Task] {
        
        guard !tags.isEmpty else {
            return [Task]()
        }
        
        var predicates = [NSPredicate]()
        for tag in tags {
            let predicate = NSPredicate(format: "ANY tags.name == %@", tag.name! )
            predicates.append(predicate)
        }
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        var tasks = [Task]()
        do {
            tasks = try PersistanceManager.instance.context.fetch(fetchRequest)
        } catch {
            os_log("Error when fetching task", log: .default, type: .error)
        }
        
        return tasks
    }
    
    func fetchTagsAssociated(with tags: [Tag]) -> [Tag] {
        
        guard !tags.isEmpty else {
            return [Tag]()
        }
        
        var predicates = [NSPredicate]()
        for tag in tags {
            let predicate = NSPredicate(format: "ANY tags.name == %@", tag.name! )
            predicates.append(predicate)
        }
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        var tagSet = Set<Tag>()
        do {
            let tasks = try PersistanceManager.instance.context.fetch(fetchRequest)
            tasks.forEach({tagSet = tagSet.union($0.tags as! Set<Tag>)})
            tagSet = tagSet.subtracting(Set(tags))
            return Array(tagSet)
            
        } catch {
            os_log("Error when fetching tag", log: .default, type: .error)
        }
        
        return Array(tagSet)
        
    }
}


