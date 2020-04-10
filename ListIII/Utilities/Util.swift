//
//  Util.swift
//  ListIII
//
//  Created by Edan on 3/8/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation

enum Util {
    static func associatedTags(for tags: [Tag]) -> [Tag] {
        if tags.isEmpty {
            let allTags = PersistanceManager.instance.fetchTags()
            return allTags
        }
        
        let associatedTags = PersistanceManager.instance.fetchTagsAssociated(with: tags)
        return associatedTags
    }
}
