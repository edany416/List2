//
//  FilterTagPickerPresenter.swift
//  ListIII
//
//  Created by Edan on 5/3/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation

protocol FilterTagPickerPresenterDelegate: class {
    func tagPickerShouldUpdate()
    func selectionItemDidUpdate()
}

class FilterTagPickerPresenter {
    
    private(set) var tagPickerSelectionManager: TableViewSelectionManager<Tag>!
    private var taskFilter: TaskFilter!
    private var tagSearch: SearchManager!
    private var tags: [Tag]!
    
    weak var delegate: FilterTagPickerPresenterDelegate?
    
    init() {
        loadData()
        tagPickerSelectionManager = TableViewSelectionManager<Tag>()
        tagPickerSelectionManager.delegate = self
        tagPickerSelectionManager.set(selectionItems: tags, sortOrder: nil)
        taskFilter = TaskFilter()
        tagSearch = SearchManager(tags.map({$0.name!}))
    }
    
    @objc private func loadData() {
        tags = PersistanceManager.instance.fetchTags()
    }
    
    func processSearchQuery(query: String, completion: (()->())?) {
        let searchResults = tagSearch.searchResults(forQuery: query)
        var resultTags = [Tag]()
        searchResults.forEach({resultTags.append(PersistanceManager.instance.fetchTag(named: $0)!)})
        tagPickerSelectionManager.set(selectionItems: resultTags, sortOrder: nil)
        completion?()
    }
    
    func applySelection(completion: (()->())?) {
        taskFilter.applyFilter()
        if let filteredTasks = taskFilter.appliedIntersection {
            //Here we need to let task table view know that it needs to be updated
        } else {
            //Here we need to let task table view know it needs to be updated with all tasks
        }
        completion?()
    }
    
    func clearTags(completion: (()->())?) {
        taskFilter.reset()
        let allTags = PersistanceManager.instance.fetchTags()
        tagPickerSelectionManager.set(selectionItems: allTags, sortOrder: nil)
        tagPickerSelectionManager.set(selectedItems: [])
        delegate?.tagPickerShouldUpdate()
        tagSearch.resetSearchItem(from: allTags.map({$0.name!}))
        
        //Need to notify task list to reset tasks
        
        completion?()
    }
    
    func cancelPendingActions(completion: (()->())?) {
        taskFilter.cancelFilter()
        let applied = taskFilter.appliedTags
        let associated = Util.associatedTags(for: applied)
        tagPickerSelectionManager.set(selectedItems: applied)
        tagPickerSelectionManager.set(selectionItems: associated, sortOrder: nil)
        delegate?.tagPickerShouldUpdate()
        completion?()
    }
}

extension FilterTagPickerPresenter: TableViewSelectionManagerDelegate {
    func updateSelectionItemsFor<T>(item: T, selected: Bool) -> [T]? where T : Comparable, T : Hashable {
        let tag = item as! Tag
        if selected {
            taskFilter.appendTag(withName: tag.name!)
        } else {
            taskFilter.removeTag(withName: tag.name!)
        }
        let pendingTags = taskFilter.pendingTags!
        let associatedTags = Util.associatedTags(for: pendingTags)
        tagSearch.resetSearchItem(from: associatedTags.map({$0.name!}))
        
        return associatedTags as? [T]
    }
    
    func cellDetails<T>(forItem item: T) -> TableViewCellDetails where T : Comparable, T : Hashable {
        let tag = item as! Tag
        let identifier = "TagFilterCell"
        let propertyModel = TagCellPropertyModel(tagName: tag.name!)
        let details = TableViewCellDetails(identifier: identifier, propertyModel: propertyModel, viewModel: TagPickerCellViewModel())
        return details
    }
    
    func didSelectItem<T>(_ item: T) where T : Comparable, T : Hashable {
        print("")
    }
    
    func didDeselectItem<T>(_ item: T) where T : Comparable, T : Hashable {
        print("")
    }
}
