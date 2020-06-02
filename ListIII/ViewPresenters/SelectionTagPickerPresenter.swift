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
    func selectedTagsDidChange(_ selected: [Tag])
    func performAddTagAction()
    func duplicateTagError()
}

class SelectionTagPickerPresenter {
    
    private var task: Task?
    private(set) var selectionManager: TableViewSelectionManager<Tag>!
    private var tagSearch: SearchManager!
    private var selectedTags: [Tag]!
    private var selectionTags: [Tag]!
    private var pendingNewTags: Set<Tag>!
    private var appliedAddedTags: Set<Tag>!
    
    weak var delegate: SelectionTagPickerPresenterDelegate?
    
    init(_ task: Task?) {
        self.task = task
        selectionManager = TableViewSelectionManager<Tag>()
        selectionManager.delegate = self
        selectedTags = [Tag]()
        selectionTags = PersistanceServices.instance.tags
        pendingNewTags = Set<Tag>()
        appliedAddedTags = Set<Tag>()
        
        if task != nil {
            selectedTags = task!.tags!.allObjects as? [Tag]
            selectionTags = Array(Set(selectionTags).subtracting(Set(selectedTags)))
        }
        
        selectionManager.set(selectedItems: selectedTags)
        selectionManager.set(selectionItems: selectionTags, sortOrder: < )
        tagSearch = SearchManager(selectionTags.map({$0.name!}))
    }
    
    func addTag(withName tagName: String) {
        if PersistanceServices.instance.tagExists(tagName) {
            delegate?.duplicateTagError()
        } else {
            let newTag = Tag(context: PersistanceManager.instance.context)
            newTag.name = tagName
            var selected = selectionManager.selectedItems
            selected.append(newTag)
            selectionManager.set(selectedItems: selected)
            pendingNewTags.insert(newTag)
            delegate?.selectedTagsDidChange(selectionManager.selectedItems)
        }
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
        delegate?.selectedTagsDidChange(selectionManager.selectedItems)
    }
    
    func didDeselectItem<T>(_ item: T) where T : Comparable, T : Hashable {
        let tag = item as! Tag
        tagSearch.insertToSearchItems(tag.name!)
        delegate?.selectedTagsDidChange(selectionManager.selectedItems)
    }
}

extension SelectionTagPickerPresenter: TagPickerViewDelegate {
    func didTapMainButton() {
        guard selectionManager.selectedItems.count != 0 else {
            print("no tags selected")
            return
        }
        let selectedSet = Set(selectionManager.selectedItems)
        var selectionSet = Set(selectionManager.selectionItems)
        pendingNewTags.forEach({
            if !selectedSet.contains($0) {
                PersistanceManager.instance.context.delete($0)
                selectionSet.remove($0)
            } else {
                appliedAddedTags.insert($0)
            }
        })
        appliedAddedTags.forEach({
            if !selectedSet.contains($0) {
                PersistanceManager.instance.context.delete($0)
                selectionSet.remove($0)
            }
        })
        
        //Set the new state here for selected and selection for when cancel is tapped again
        selectedTags = selectionManager.selectedItems
        selectionTags = Array(selectionSet)
        selectionManager.set(selectionItems: selectionTags, sortOrder: < )
        pendingNewTags.removeAll()
        delegate?.userDidSelectTags(selectedTags)
    }
    
    //Cancel shouldn't always remove all added tags
    //Possible solution, make a list of applied new tags,
    //then added tags is a list of pending tags
    func didTapTopLeftButton() {
        pendingNewTags.forEach({PersistanceManager.instance.context.delete($0)})
        pendingNewTags.removeAll()
        selectionManager.set(selectionItems: selectionTags, sortOrder: < )
        selectionManager.set(selectedItems: selectedTags)
        delegate?.perfomCancelAction()
    }
    
    func didTapTopRightButton() {
        delegate?.performAddTagAction()
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
