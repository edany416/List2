//
//  TagSorter.swift
//  List2
//
//  Created by edan yachdav on 8/20/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import Foundation

enum SortingType {
    case alpha
    case associatedTasks
}

struct TagSorter {

    private var sortType: SortingType = .alpha
    
    mutating func setSortType(to sortType: SortingType) {
        self.sortType = sortType
    }
    
    func sort(tags: [Tag]) -> [Tag] {
        switch sortType {
        case .alpha:
            return tags.sorted(by: {$0.name! < $1.name!})
        case .associatedTasks:
            return tags.sorted(by: {$0.tasks!.count < $1.tasks!.count})
        }
    }
    
}
