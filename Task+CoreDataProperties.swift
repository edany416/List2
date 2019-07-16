//
//  Task+CoreDataProperties.swift
//  
//
//  Created by edan yachdav on 7/15/19.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var dueDate: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var tags: NSSet?

}

// MARK: Generated accessors for tags
extension Task {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
