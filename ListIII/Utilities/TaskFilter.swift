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
    private(set) var appliedIntersection: [Task]?
    private(set) var pendingIntersection: [Task]?
    
    init() {
        appliedTags = [Tag]()
    }
    
    mutating func appendTag(withName tagName: String) {
        let tag = PersistanceManager.instance.fetchTag(named: tagName)!
        if pendingTags == nil {
            pendingTags = appliedTags
            pendingIntersection = appliedIntersection
        }
        guard !pendingTags!.contains(tag) else {
            return
        }
        pendingTags!.append(tag)
        pendingIntersection = PersistanceManager.instance.fetchTasks(for: pendingTags!)
    }
    
    mutating func removeTag(withName tagName: String) {
        pendingIntersection = nil
        if pendingTags == nil {
            pendingTags = appliedTags.filter({$0.name! != tagName})
        } else {
            pendingTags = pendingTags!.filter({$0.name! != tagName})
        }
        if !pendingTags!.isEmpty {
            pendingIntersection = PersistanceManager.instance.fetchTasks(for: pendingTags!)
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
    
    mutating func reset() {
        appliedTags = [Tag]()
        pendingTags = nil
        appliedIntersection = nil
        pendingIntersection = nil
    }
    
    mutating func cancelFilter() {
        pendingTags = nil
        pendingIntersection = nil
    }
}
