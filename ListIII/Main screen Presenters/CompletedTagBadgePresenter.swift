//
//  CompletedTagBadgePresenter.swift
//  ListIII
//
//  Created by Edan on 6/9/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation

class CompletedTagBadgePresenter {
    
    private var completedTagsList: [String]!
    var completedTags: String {
        return completedTagsList.joined(separator: ", ")
    }
    
    init() {
        completedTagsList = [String]()
    }
    
    func setCompletedTags(_ tags: [String]) {
        self.completedTagsList = tags
    }
    
}
