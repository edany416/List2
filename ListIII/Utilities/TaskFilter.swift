//
//  TaskFilter.swift
//  ListIII
//
//  Created by Edan on 2/27/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation

enum TaskFilter {
    static func numTasksForTags(named tagNams: [String]) -> Int {
        return self.getIntersection(tagNames: tagNams).count
    }
    
    static func tasksForTags(named tagNames: [String]) -> [Task]{
        return self.getIntersection(tagNames: tagNames)
    }
    
    private static func getIntersection(tagNames: [String]) -> [Task] {
        var tags = [Tag]()
        for tagName in tagNames {
            if let tag = PersistanceManager.instance.fetchTag(named: tagName) {
                tags.append(tag)
            }
        }
        
        if tags.isEmpty {
            return [Task]()
        }
        
        var intersection: Set<Task>?
        for tag in tags {
            if intersection == nil {
                intersection = tag.tasks as? Set<Task>
            } else {
                intersection = intersection!.intersection(tag.tasks as! Set<Task>)
            }
        }
        
        return Array(intersection!)
    }
}
