//
//  TaskFilter.swift
//  ListIII
//
//  Created by Edan on 2/27/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation

struct TaskFilter {
    
    var appliedTags: [Tag] {
        return confirmedTags
    }
    
    private var confirmedTags: [Tag] {
        didSet{
            if self.confirmedTags.isEmpty {
                appliedIntersection = nil
            }
        }
    }
    private var appliedIntersection: Set<Task>?
    private var isInInitialState: Bool {
        return pendingTags == nil && confirmedTags.isEmpty
    }
    private var isInPendingState: Bool {
        return pendingTags != nil
    }
    
    init() {
        confirmedTags = [Tag]()
    }
    
    private var pendingTags: [Tag]?
    private var pendingIntersection: Set<Task>?
    mutating func appendTag(withName tagName: String) -> Int {
        if let tag = PersistanceManager.instance.fetchTag(named: tagName), let tasks = tag.tasks as? Set<Task> {  
            if !isInPendingState {
                pendingTags = confirmedTags
                pendingIntersection = appliedIntersection
            }
            
            pendingTags!.append(tag)
            if pendingIntersection == nil {
                pendingIntersection = tasks
            } else {
                pendingIntersection = pendingIntersection!.intersection(tasks)
            }
        }
        return pendingIntersection!.count
    }
    
    mutating func removeTag(withName tagName: String) -> Int? {
        pendingIntersection = nil
        if !isInPendingState {
            pendingTags = confirmedTags.filter({$0.name! != tagName})
        } else { //In pending state pending tags includes the applied tags
            pendingTags = pendingTags!.filter({$0.name! != tagName})
        }
        
        if pendingTags!.isEmpty {
            return nil
        }
        
        for tag in pendingTags! {
            let tasks = tag.tasks as! Set<Task>
            if pendingIntersection == nil {
                pendingIntersection = tasks
            } else {
                pendingIntersection = pendingIntersection?.intersection(tasks)
            }
        }
        
        return pendingIntersection!.count
    }

    
    mutating func apply() -> [Task]? {
        if isInInitialState {
            return nil
        }
        if !isInPendingState && !confirmedTags.isEmpty {
            return Array(appliedIntersection!)
        }
        
        confirmedTags = pendingTags!
        appliedIntersection = pendingIntersection
        
        pendingTags = nil
        pendingIntersection = nil
        
        return appliedIntersection == nil ? nil : Array(appliedIntersection!)
        
    }

    mutating func cancel() {
        pendingTags = nil
        pendingIntersection = nil
    }
}

