//
//  SearchManager.swift
//  ListIII
//
//  Created by Edan on 3/29/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation

struct SearchManager {
    private var searchableItems: Set<String> //Avilable items
    
    init(_ searchItems: [String]) {
        searchableItems = Set(searchItems)
    }
    
    func searchResults(forQuery query: String) -> [String] {
        var result = Set<String>()
        if query.isEmpty {
            result = searchableItems
        } else {
            searchableItems.forEach({
                if $0.contains(query) {
                    result.insert($0)
                }
            })
        }
        
        return Array(result)
    }
    
    mutating func resetSearchItem(from items: [String]) {
        searchableItems = Set(items)
    }
    
    mutating func insertToSearchItems(_ item: String) {
        searchableItems.insert(item)
    }
}
