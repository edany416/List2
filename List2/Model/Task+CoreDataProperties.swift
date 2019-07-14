//
//  Task+CoreDataProperties.swift
//  
//
//  Created by edan yachdav on 7/12/19.
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

}
