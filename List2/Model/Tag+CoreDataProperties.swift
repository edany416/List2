//
//  Tag+CoreDataProperties.swift
//  List2
//
//  Created by edan yachdav on 7/29/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var name: String?
    @NSManaged public var tasks: NSSet?
    @NSManaged public var isSaved: Bool
    @NSManaged public var associatedTags: NSSet?
    

}

// MARK: Generated accessors for tasks
extension Tag: Comparable {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)
}

// MARK: Generated accessors for associatedTags
extension Tag {

    @objc(addAssociatedTagsObject:)
    @NSManaged public func addToAssociatedTags(_ value: Tag)

    @objc(removeAssociatedTagsObject:)
    @NSManaged public func removeFromAssociatedTags(_ value: Tag)

    @objc(addAssociatedTags:)
    @NSManaged public func addToAssociatedTags(_ values: NSSet)

    @objc(removeAssociatedTags:)
    @NSManaged public func removeFromAssociatedTags(_ values: NSSet)
    
    public static func < (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.name! < rhs.name!
    }
    
    public static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.name! == rhs.name!
    }
    

}
