//
//  SelectionTagPickerPresenter.swift
//  ListIII
//
//  Created by Edan on 5/28/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation

protocol SelectionTagPickerPresenterDelegate: class {
    func userDidPerformTagSearch()
    func perfomCancelAction()
    func userDidSelectTags(_ tags: [Tag])
}

class SelectionTagPickerPresenter {
    
    private var task: Task?
    private(set) var selectionManager: TableViewSelectionManager<Tag>!
    private var tagSearch: SearchManager!
    private var selectedTags: [Tag]!
    private var selectionTags: [Tag]!
    private var addedTags: [Tag]!
    
    weak var delegate: SelectionTagPickerPresenterDelegate?
    
    init(_ task: Task?) {
        self.task = task
        selectionManager = TableViewSelectionManager<Tag>()
        selectionManager.delegate = self
        selectedTags = [Tag]()
        selectionTags = PersistanceServices.instance.tags
        addedTags = [Tag]()
        
        if task != nil {
            selectedTags = task!.tags!.allObjects as? [Tag]
            selectionTags = Array(Set(selectionTags).subtracting(Set(selectedTags)))
        }
        
        selectionManager.set(selectedItems: selectedTags)
        selectionManager.set(selectionItems: selectionTags, sortOrder: < )
        tagSearch = SearchManager(selectionTags.map({$0.name!}))
    }
}

extension SelectionTagPickerPresenter: TableViewSelectionManagerDelegate {
    func updateSelectionItemsFor<T>(item: T, selected: Bool) -> [T]? where T : Comparable, T : Hashable {
        return nil
    }
    
    func cellDetails<T>(forItem item: T) -> TableViewCellDetails where T : Comparable, T : Hashable {
        let tag = item as! Tag
        let identifier = "TagFilterCell"
        let propertyModel = TagCellPropertyModel(tagName: tag.name!)
        let details = TableViewCellDetails(identifier: identifier, propertyModel: propertyModel, viewModel: TagPickerCellViewModel())
        return details
    }
    
    func didSelectItem<T>(_ item: T) where T : Comparable, T : Hashable {
        let tag = item as! Tag
        tagSearch.removeFromSearchItem(tag.name!)
    }
    
    func didDeselectItem<T>(_ item: T) where T : Comparable, T : Hashable {
        let tag = item as! Tag
        tagSearch.insertToSearchItems(tag.name!)
    }
}

extension SelectionTagPickerPresenter: TagPickerViewDelegate {
    func didTapMainButton() {
        selectedTags = selectionManager.selectedItems
        selectionTags = selectionManager.selectionItems
        delegate?.userDidSelectTags(selectedTags)
    }
    
    func didTapTopLeftButton() {
        addedTags.forEach({PersistanceManager.instance.context.delete($0)})
        addedTags.removeAll()
        selectionManager.set(selectionItems: selectionTags, sortOrder: < )
        selectionManager.set(selectedItems: selectedTags)
        delegate?.perfomCancelAction()
    }
    
    func didTapTopRightButton() {
        print("Did tap top right")
    }
    
    func didSearch(for query: String) {
        let results = tagSearch.searchResults(forQuery: query)
        selectionTags.removeAll()
        results.forEach({
            selectionTags.append(PersistanceManager.instance.fetchTag(named: $0)!)
        })
        selectionManager.set(selectionItems: selectionTags, sortOrder: < )
        delegate?.userDidPerformTagSearch()
    }
}
