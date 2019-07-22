//
//  Tag+CoreDataProperties.swift
//  
//
//  Created by edan yachdav on 7/15/19.
//
//

import Foundation
import CoreData


extension Tag: Comparable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var name: String?
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension Tag {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)
    
    public static func < (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.name! < rhs.name!
    }
    

}
