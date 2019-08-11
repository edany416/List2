//
//  TapTracker.swift
//  List2
//
//  Created by edan yachdav on 8/11/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import Foundation

struct TapTracker {
    private var tracker: [String:Bool]!
    init(tags: [Tag]) {
        tracker = Dictionary(uniqueKeysWithValues: tags.map { ($0.name! , false) })
    }
    
    mutating func setTappedStatus(for tag: Tag) {
        let tagName = tag.name!
        let tapStatus = tracker[tagName]
        tracker[tagName] = !tapStatus!
    }
    
    mutating func setTappedStatus(forTagNamed name: String) {
        let tapStatus = tracker[name]
        tracker[name] = !tapStatus!
    }
    
    func tapStatus(for tag: Tag) -> Bool {
        let tagName = tag.name!
        return tracker[tagName]!
    }
    
    func tapStatus(forTagNamed name: String) -> Bool {
        return tracker[name]!
    }
}
