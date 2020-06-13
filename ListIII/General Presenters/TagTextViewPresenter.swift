//
//  TagTextViewPresenter.swift
//  ListIII
//
//  Created by Edan on 6/11/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation

struct TagTextViewPresenter {
    
    private var tags: [Tag]!
    var tagString: String {
        if tags.isEmpty {
           return placeholder
        } else {
            let tagNames = tags.map({$0.name!})
            let concatinatedTags = tagNames.joined(separator: " \u{2022} ")
            return concatinatedTags
        }
    }
    
    private var placeholder: String = "Tap here to view tags"
    
    init(_ tags: [Tag]) {
        self.tags = tags
    }
    
    mutating func setPlaceholder(text: String) {
        self.placeholder = text
    }
}
