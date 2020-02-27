//
//  TestUtilities.swift
//  ListIII
//
//  Created by Edan on 2/26/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation

enum TestUtilities {
    static func loadTagsFromJSON() -> [Tag] {
        var tags = [Tag]()
        let url = Bundle.main.url(forResource: "tags", withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            let parsedTags = try JSONSerialization.jsonObject(with: jsonData) as! [[String: String]]
            for tag in parsedTags {
                let newTag = Tag(context: PersistanceManager.instance.context)
                newTag.name = tag["name"]
                newTag.selected = false
                tags.append(newTag)
            }
        }
        catch {
            print(error)
        }
        
        return tags
    }
}
