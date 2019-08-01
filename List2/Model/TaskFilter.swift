//
//  TaskFilter.swift
//  List2
//
//  Created by edan yachdav on 7/20/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import Foundation



struct TaskFilter {

    private var selectedTags = Set<Tag>()
    private var filteredTasks = Set<Task>()
    private var defaultTags: Set<Tag>!
    private var defaultTasks: [Task]!
    private var tagFilter: TagFilter!
    var  isInFilterMode: Bool {
        return selectedTags.count != 0
    }
    
    init(defaultTags: Set<Tag>) {
        self.defaultTags = defaultTags
        var taskSet = Set<Task>()
        for tag in defaultTags {
            let tasksForTag = tag.tasks?.allObjects as? [Task]
            taskSet = taskSet.union(tasksForTag!)
        }
        defaultTasks = Array(taskSet)
        tagFilter = TagFilter(defaultTags)
    }
    
    
    mutating func filterTasksForTag(tag: Tag) -> [Task] {
        if !selectedTags.contains(tag) {
            return addTagToFilter(tag: tag)
        } else {
            return removeTagFromFilter(tag: tag)
        }
    }
    
    mutating func tagList(for tag: Tag) -> [Tag] {
        return tagFilter.associatedTags(for: tag)
    }
    
    private mutating func addTagToFilter(tag: Tag) -> [Task] {
        var tasks: [Task]!
        if selectedTags.count == 0 {
            tasks = tag.tasks?.allObjects as? [Task]
            selectedTags.insert(tag)
            filteredTasks = Set(tasks)
            return tasks
        }
        selectedTags.insert(tag)
        filteredTasks = filteredTasks.intersection(tag.tasks! as! Set<Task>)
        tasks = Array(filteredTasks)
        return tasks
    }
    
    private mutating func removeTagFromFilter(tag: Tag) -> [Task] {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
            if selectedTags.count == 0 {
                return defaultTasks
            } else {
                var taskSet: Set<Task>?
                for tag in selectedTags {
                    let tasksForTag = tag.tasks as! Set<Task>
                    if taskSet == nil {
                        taskSet = Set(tasksForTag)
                    } else {
                        taskSet = taskSet!.intersection(tasksForTag)
                    }
                }
                filteredTasks = taskSet!
            }
        }
        return Array(filteredTasks)
    }
}
