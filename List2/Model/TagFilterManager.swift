//
//  TagFilterManager.swift
//  
//
//  Created by edan yachdav on 7/18/19.
//

import Foundation

class TagFilterManager {
    private var selectedTags: Set<String>
    private var tasksForSelectedTags: Set<Task>
    
    init() {
        selectedTags = Set<String>()
        tasksForSelectedTags = Set<Task>()
    }
    
    func filter(_ tagName: String) -> Set<Task> {
        let tag = PersistanceService.instance.fetchTag(for: Tag.fetchRequest(), named: tagName)
        selectedTags.insert(tagName)
        let tasksArray = tag!.tasks!.allObjects as! [Task]
        if tasksForSelectedTags.count == 0 {
            for task in tasksArray {
                tasksForSelectedTags.insert(task)
            }
        } else {
            tasksForSelectedTags = tasksForSelectedTags.intersection(tasksArray)
        }
        return tasksForSelectedTags
    }
}
