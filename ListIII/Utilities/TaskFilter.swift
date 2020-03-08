//
//  TaskFilter.swift
//  ListIII
//
//  Created by Edan on 2/27/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation

//Returns tasks for a selection of tags
struct TaskFilter {
    private(set) var appliedTags: [Tag]
    private(set) var pendingTags: [Tag]?
    private(set) var appliedIntersection: Set<Task>?
    private(set) var pendingIntersection: Set<Task>?
    
    init() {
        appliedTags = [Tag]()
    }
    
    mutating func appendTag(withName tagName: String) {
        let tag = PersistanceManager.instance.fetchTag(named: tagName)!
        let tasksForTag = tag.tasks as! Set<Task>
                
        if pendingTags == nil {
            pendingTags = appliedTags
            pendingIntersection = appliedIntersection
        }
        
        guard !pendingTags!.contains(tag) else {
            return
        }
        
        pendingTags!.append(tag)
        computeIntersection(from: tasksForTag)
    }
    
    mutating func removeTag(withName tagName: String) {
        pendingIntersection = nil
        if pendingTags == nil {
            pendingTags = appliedTags.filter({$0.name! != tagName})
        } else {
            pendingTags = pendingTags?.filter({$0.name! != tagName})
        }
        
        for tag in pendingTags! {
            let tasksForTag = tag.tasks as! Set<Task>
            computeIntersection(from: tasksForTag)
        }
    }
    
    mutating func applyFilter() {
        if pendingTags != nil {
            appliedTags = pendingTags!
            appliedIntersection = pendingIntersection
            
            pendingTags = nil
            pendingIntersection = nil
        }
    }
    
    mutating func cancelFilter() {
        pendingTags = nil
        pendingIntersection = nil
    }
    
    private mutating func computeIntersection(from tasks: Set<Task>) {
        if pendingIntersection == nil {
            pendingIntersection = tasks
        } else {
            pendingIntersection = pendingIntersection?.intersection(tasks)
        }
    }
}
