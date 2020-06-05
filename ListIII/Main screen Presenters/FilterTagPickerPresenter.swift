//
//  FilterTagPickerPresenter.swift
//  ListIII
//
//  Created by Edan on 6/2/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation

protocol FilterTagPickerPresenterDelegate: class {
    func didApplySelectedTags(_ tags: [Tag])
    func didSelectTag(_ tag: Tag)
    func didDeselectTag(_ tag: Tag)
    func selectedTagsDidChange() //Changed but not applied yet
    func didCancelSelection()
    func didPerformTagSearch()
    func didClearAllSelectedTags()
}

class FilterTagPickerPresenter {
    
    private var tags: [Tag]!
    
    private(set) var tableViewSelectionManager: TableViewSelectionManager<Tag>!
    private var tagSearch: SearchManager!
    private var revertSelectedTags: [Tag]!
    weak var delegate: FilterTagPickerPresenterDelegate?
    
    init(fromSelectedTags selectedTags: [Tag], selectionTags: [Tag], allAvailableTags: [Tag]) {
        self.tags = allAvailableTags
        tableViewSelectionManager = TableViewSelectionManager<Tag>()
        tableViewSelectionManager.delegate = self
        tableViewSelectionManager.set(selectedItems: selectedTags)
        tableViewSelectionManager.set(selectionItems: selectionTags, sortOrder: < )
        tagSearch = SearchManager(selectionTags.map({$0.name!}))
        revertSelectedTags = selectedTags
    }
    
    func set(selectedTags: [Tag], selectionTags: [Tag], allAvailableTags: [Tag]) {
        tags = allAvailableTags
        tableViewSelectionManager.set(selectedItems: selectedTags)
        tableViewSelectionManager.set(selectionItems: selectionTags, sortOrder: < )
        tagSearch.resetSearchItem(from: selectionTags.map({$0.name!}))
        revertSelectedTags = selectedTags
        
    }
}

extension FilterTagPickerPresenter: TableViewSelectionManagerDelegate {
    func updateSelectionItemsFor<T>(item: T, selected: Bool) -> [T]? where T : Comparable, T : Hashable {
        let tag = item as! Tag
        switch selected {
        case true:
            delegate?.didSelectTag(tag)
        case false:
            delegate?.didDeselectTag(tag)
        }
        let associatedTags = Util.associatedTags(for: tableViewSelectionManager.selectedItems)
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
        delegate?.selectedTagsDidChange()
    }
    
    func didDeselectItem<T>(_ item: T) where T : Comparable, T : Hashable {
        delegate?.selectedTagsDidChange()
    }
}

extension FilterTagPickerPresenter: TagPickerViewDelegate {
    func didTapMainButton() {
        revertSelectedTags = tableViewSelectionManager.selectedItems
        delegate?.didApplySelectedTags(tableViewSelectionManager.selectedItems)
    }
    
    func didTapTopLeftButton() {
        let associatedTags = Util.associatedTags(for: revertSelectedTags)
        tableViewSelectionManager.set(selectedItems: revertSelectedTags)
        tableViewSelectionManager.set(selectionItems: associatedTags, sortOrder: < )
        delegate?.didCancelSelection()
    }
    
    func didTapTopRightButton() {
        tableViewSelectionManager.set(selectionItems: tags, sortOrder: < )
        tableViewSelectionManager.set(selectedItems: [])
        tagSearch.resetSearchItem(from: tags.map({$0.name!}))
        revertSelectedTags.removeAll()
        delegate?.didClearAllSelectedTags()
    }
    
    func didSearch(for query: String) {
        let searchResult = tagSearch.searchResults(forQuery: query)
        var resultTags = [Tag]()
        searchResult.forEach({
            resultTags.append(PersistanceManager.instance.fetchTag(named: $0)!)
        })
        tableViewSelectionManager.set(selectionItems: resultTags, sortOrder: < )
        delegate?.didPerformTagSearch()
    }
}
