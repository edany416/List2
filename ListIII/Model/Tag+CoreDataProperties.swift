//
//  Tag+CoreDataProperties.swift
//  ListIII
//
//  Created by Edan on 2/27/20.
//  Copyright © 2020 Edan. All rights reserved.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var name: String?
    @NSManaged public var selected: Bool
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for task
extension Tag {

    @objc(addTaskObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTaskObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTask:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTask:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

    public static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.name!.caseInsensitiveCompare(rhs.name!) == .orderedSame
    }
}
