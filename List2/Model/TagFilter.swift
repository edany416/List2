//
//  TagFilter.swift
//  List2
//
//  Created by edan yachdav on 7/30/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import Foundation

struct TagFilter {
    private var selectedTags = [Tag]()
    private var filteredTags = [Tag]()
    private var defaultTags: Set<Tag>!
    
    init(_ defaultTags: Set<Tag>) {
        self.defaultTags = defaultTags
    }
    
    mutating func associatedTags(for tag: Tag) -> [Tag] {
        
        if !selectedTags.contains(tag) {
            selectedTags.append(tag)
            if selectedTags.count == 1 {
                let associatedTags = tag.associatedTags!.allObjects as! [Tag]
                filteredTags = selectedTags + associatedTags
            } else {
                var associatedTags: Set<Tag>?
                for tag in selectedTags {
                    if associatedTags == nil {
                        associatedTags = Set(tag.associatedTags as! Set<Tag>)
                    } else {
                        associatedTags = associatedTags!.intersection(tag.associatedTags as! Set<Tag>)
                    }
                }
                filteredTags = selectedTags + Array(associatedTags!)
            }
        } else {
            for (index, currTag) in selectedTags.enumerated() {
                if currTag.name == tag.name {
                    selectedTags.remove(at: index)
                }
            }
            
            if selectedTags.count == 0 {
                filteredTags = Array(defaultTags)
            } else {
                var associatedTags: Set<Tag>?
                for tag in selectedTags {
                    if associatedTags == nil {
                        associatedTags = Set(tag.associatedTags as! Set<Tag>)
                    } else {
                        associatedTags = associatedTags!.intersection(tag.associatedTags as! Set<Tag>)
                    }
                }
                filteredTags = selectedTags + Array(associatedTags!)
            }
        }
        return filteredTags
    }
}
