//
//  TaskDetailViewControllerPresenter.swift
//  ListIII
//
//  Created by Edan on 4/24/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation

protocol TaskDetailViewControllerPresenterDelegate: class {
    func shouldConfigureForEditMode(_ editting: Bool, _ taskName: String, _ tags:[String])
    func showTagPickerView()
    func performApplyActionForSelectedTags(_ tags: [String])
    func performCancelAction()
    func presentNewTagForm()
    func saveDidSucceed()
    func saveDidFailWithMessage(_ message: String)
    func userPerformedTagSearch()
}

class TaskDetailViewControllerPresenter {
    
    weak var delegate: TaskDetailViewControllerPresenterDelegate!
    private var task: Task?
    private var isInEditMode: Bool!
    private(set) var selectionManager: TableViewSelectionManager<Tag>!
    private var revertSelectedTags: [Tag]!
    private var revertSelectionTags: [Tag]!
    private var tagSearch: SearchManager!
    
    private enum SaveErrors: String {
        case emptyTaskName = "Task name field is empty"
        case emptyTags = "No tags have been selected"
        case emptyForm = "Must add task name and tags"
    }
    
    init(_ task: Task?, _ delegate: TaskDetailViewControllerPresenterDelegate) {
        self.task = task
        self.delegate = delegate
        isInEditMode = self.task != nil
        let allTags =  PersistanceManager.instance.fetchTags()
        tagSearch = SearchManager(allTags.map({$0.name!}))
        selectionManager = TableViewSelectionManager()
        if self.task == nil {
            selectionManager.set(selectionItems: allTags, sortOrder: nil)
            self.delegate.shouldConfigureForEditMode(false, "", [])
        } else {
            let allTagsSet = Set(allTags)
            let taskTagsSet = task!.tags as! Set<Tag>
            selectionManager.set(selectionItems: Array(allTagsSet.subtracting(taskTagsSet)), sortOrder: nil)
            selectionManager.set(selectedItems: Array(taskTagsSet))
            self.delegate.shouldConfigureForEditMode(true, task!.taskName!, Array(taskTagsSet).map({$0.name!}))
        }
        selectionManager.delegate = self
        revertSelectedTags = [Tag]()
        revertSelectionTags = [Tag]()
    }
    
    func addTag(_ tag: String, completion: (()->())?) {
        let newTag = Tag(context: PersistanceManager.instance.context)
        newTag.name = tag
        var selectedTags = selectionManager.selectedItems
        selectedTags.append(newTag)
        selectionManager.set(selectedItems: selectedTags)
        tagSearch.insertToSearchItems(tag)
        completion?()
    }
    
    func save(_ task: String, _ tags: [String]) {
        if task.isEmpty && tags.isEmpty {
            delegate.saveDidFailWithMessage(SaveErrors.emptyForm.rawValue)
        } else if task.isEmpty {
            delegate.saveDidFailWithMessage(SaveErrors.emptyTaskName.rawValue)
        } else if tags.isEmpty {
            delegate.saveDidFailWithMessage(SaveErrors.emptyTags.rawValue)
        } else {
            if isInEditMode {
                PersistanceManager.instance.updateTask(withId: self.task!.id!, task, associatedTags: tags)
            } else {
                PersistanceManager.instance.createNewTask(task, associatedTags: tags)
            }
            delegate.saveDidSucceed()
        }
    }
}

extension TaskDetailViewControllerPresenter: TagsTextViewDelegate {
    func didTapTextView() {
        revertSelectedTags = selectionManager.selectedItems
        revertSelectionTags = selectionManager.selectionItems
        delegate.showTagPickerView()
    }
}

extension TaskDetailViewControllerPresenter: TagPickerViewDelegate {
    func didTapMainButton() {
        delegate.performApplyActionForSelectedTags(selectionManager.selectedItems.map({$0.name!}))
    }
    
    func didTapTopLeftButton() {
        selectionManager.set(selectedItems: revertSelectedTags)
        selectionManager.set(selectionItems: revertSelectionTags, sortOrder: nil)
        delegate.performCancelAction()
    }
    
    func didTapTopRightButton() {
        delegate.presentNewTagForm()
    }
    
    func didSearch(for query: String) {
        let searchResults = tagSearch.searchResults(forQuery: query)
        var resultTags = [Tag]()
        searchResults.forEach({resultTags.append(PersistanceManager.instance.fetchTag(named: $0)!)})
        selectionManager.set(selectionItems: resultTags, sortOrder: nil)
        delegate.userPerformedTagSearch()
    }
}

extension TaskDetailViewControllerPresenter: TableViewSelectionManagerDelegate {
    func didSelectItem<T>(_ item: T) where T : Comparable, T : Hashable {
        let tag = item as! Tag
        tagSearch.removeFromSearchItem(tag.name!)
    }
    
    func didDeselectItem<T>(_ item: T) where T : Comparable, T : Hashable {
        let tag = item as! Tag
        tagSearch.insertToSearchItems(tag.name!)
    }
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
}
