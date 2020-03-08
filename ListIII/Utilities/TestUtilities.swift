//
//  TestUtilities.swift
//  ListIII
//
//  Created by Edan on 2/26/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation

enum TestUtilities {
    static func setupDB(from resourses: String){
        let url = Bundle.main.url(forResource: resourses, withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            let parsedTasks = try JSONSerialization.jsonObject(with: jsonData) as! [[String: Any]]
            for task in parsedTasks {
                let name = task["name"]! as! String
                let id = task["id"]! as! String
                let associatedTags = task["tags"]! as! [String]
                PersistanceManager.instance.createNewTask(name, id, associatedTags: associatedTags)
            }
        }
        catch {
            print(error)
        }
    }
}
