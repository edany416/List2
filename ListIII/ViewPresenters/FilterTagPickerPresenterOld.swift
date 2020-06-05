//
//  FilterTagPickerPresenter.swift
//  ListIII
//
//  Created by Edan on 5/3/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation

protocol FilterTagPickerPresenterDelegateOld: class {
    func selectionItemsDidUpdate()
    func selectedItemsDidChange()
}

class FilterTagPickerPresenterOld {
    
    private(set) var tagPickerSelectionManager: TableViewSelectionManager<Tag>!
    private var taskFilter: TaskFilter!
    private var tagSearch: SearchManager!
    private var tags: [Tag]!
    
    weak var delegate: FilterTagPickerPresenterDelegateOld?
    
    init() {
        loadData()
        tagPickerSelectionManager = TableViewSelectionManager<Tag>()
        tagPickerSelectionManager.delegate = self
        tagPickerSelectionManager.set(selectionItems: tags, sortOrder: nil)
        taskFilter = TaskFilter()
        tagSearch = SearchManager(tags.map({$0.name!}))
        
        NotificationCenter.default.addObserver(self, selector: #selector(modelDidUpdate), name: .DidCreateNewTaskNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(modelDidUpdate), name: .DidEditTaskNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(modelDidUpdate), name: .DidDeleteTaskNotification, object: nil)
        
    }
    
    @objc private func loadData() {
        tags = PersistanceManager.instance.fetchTags()
    }
    
    @objc private func modelDidUpdate() {
        loadData()
        tagPickerSelectionManager.set(selectionItems: tags, sortOrder: nil)
        tagSearch = SearchManager(tags.map({$0.name!}))
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
        var tasks = [Task]()
        let tags = tagPickerSelectionManager.selectedItems
        if let filteredTasks = taskFilter.appliedIntersection {
            tasks = filteredTasks
        } else {
            tasks = PersistanceManager.instance.fetchTasks()
        }
        NotificationCenter.default.post(name: Notification.Name.TagsChagnedNotification, object: nil, userInfo: ["Tasks":tasks])
        NotificationCenter.default.post(name: Notification.Name.SelectedTagsDidChangeNotification, object: nil, userInfo: ["Tags":tags])
        completion?()
    }
    
    func clearTags(completion: (()->())?) {
        taskFilter.reset()
        let allTags = PersistanceManager.instance.fetchTags()
        tagPickerSelectionManager.set(selectionItems: allTags, sortOrder: nil)
        tagPickerSelectionManager.set(selectedItems: [])
        tagSearch.resetSearchItem(from: allTags.map({$0.name!}))
        let tasks = PersistanceManager.instance.fetchTasks()
        NotificationCenter.default.post(name: Notification.Name.TagsChagnedNotification, object: nil, userInfo: ["Tasks":tasks])
        completion?()
    }
    
    func cancelPendingActions(completion: (()->())?) {
        taskFilter.cancelFilter()
        let applied = taskFilter.appliedTags
        let associated = Util.associatedTags(for: applied)
        tagPickerSelectionManager.set(selectedItems: applied)
        tagPickerSelectionManager.set(selectionItems: associated, sortOrder: nil)
        completion?()
    }
}

extension FilterTagPickerPresenterOld: TableViewSelectionManagerDelegate {
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
        delegate?.selectionItemsDidUpdate()
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
        delegate?.selectedItemsDidChange()
    }
    
    func didDeselectItem<T>(_ item: T) where T : Comparable, T : Hashable {
        delegate?.selectedItemsDidChange()
    }
}

extension Notification.Name {
    
    static let TagsChagnedNotification = Notification.Name("tagsChangedNotification")
    static let SelectedTagsDidChangeNotification = Notification.Name("selectedTagsDidChange")
}
