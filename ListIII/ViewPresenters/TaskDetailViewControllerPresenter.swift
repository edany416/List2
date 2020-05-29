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
    func saveDidFailWithMessage(_ error: ErrorType)
    func userPerformedTagSearch()
    func selectedTagsDidChange()
    func duplicateTagAdded(_ tagName: String)
}

class TaskDetailViewControllerPresenter {
    
    weak var delegate: TaskDetailViewControllerPresenterDelegate!
    private var task: Task?
    private var isInEditMode: Bool!
    private(set) var selectionManager: TableViewSelectionManager<Tag>!
    private var revertSelectedTags: [Tag]!
    private var revertSelectionTags: [Tag]!
    private var tagSearch: SearchManager!
    private var addedTags: Set<Tag>!
    
    init(_ task: Task?, _ delegate: TaskDetailViewControllerPresenterDelegate) {
        self.task = task
        self.delegate = delegate
        isInEditMode = self.task != nil
        addedTags = Set<Tag>()
        let allTags =  PersistanceManager.instance.fetchTags()
        
        selectionManager = TableViewSelectionManager()
        if self.task == nil {
            selectionManager.set(selectionItems: allTags, sortOrder: nil)
            self.delegate.shouldConfigureForEditMode(false, "", [])
            tagSearch = SearchManager(allTags.map({$0.name!}))
            NotificationCenter.default.addObserver(self, selector: #selector(saveDidSucceed), name: .DidCreateNewTaskNotification, object: nil)
        } else {
            let allTagsSet = Set(allTags)
            let taskTagsSet = task!.tags as! Set<Tag>
            selectionManager.set(selectionItems: Array(allTagsSet.subtracting(taskTagsSet)), sortOrder: nil)
            selectionManager.set(selectedItems: Array(taskTagsSet))
            tagSearch = SearchManager(Array(allTagsSet.subtracting(taskTagsSet)).map({$0.name!}))
            self.delegate.shouldConfigureForEditMode(true, task!.taskName!, Array(taskTagsSet).map({$0.name!}))
            NotificationCenter.default.addObserver(self, selector: #selector(saveDidSucceed), name: .DidEditTaskNotification, object: nil)
        }
        selectionManager.delegate = self
        revertSelectedTags = [Tag]()
        revertSelectionTags = [Tag]()
    }
    
    func addTag(_ tag: String, completion: (()->())?) {
        if PersistanceServices.instance.tagExists(tag) {
            delegate?.duplicateTagAdded(tag)
        } else {
            let newTag = Tag(context: PersistanceManager.instance.context)
            newTag.name = tag
            var selectedTags = selectionManager.selectedItems
            selectedTags.append(newTag)
            selectionManager.set(selectedItems: selectedTags)
            tagSearch.insertToSearchItems(tag)
            delegate.selectedTagsDidChange()
            addedTags.insert(newTag)
            completion?()
        }
    }
    
    func save(_ task: String, _ tags: [String]) {
        if task.isEmpty && tags.isEmpty {
            delegate.saveDidFailWithMessage(.emptyForm)
        } else if task.isEmpty {
            delegate.saveDidFailWithMessage(.emptyTaskName)
        } else if tags.isEmpty {
            delegate.saveDidFailWithMessage(.emptyTags)
        } else {
            if isInEditMode {
                PersistanceServices.instance.editTask(withId: self.task!.id!, taskName: task, associatedTags: tags)
            } else {
                PersistanceServices.instance.saveNewTask(task, tags)
            }
        }
    }
    
    @objc private func saveDidSucceed() {
        NotificationCenter.default.removeObserver(self)
        delegate.saveDidSucceed()
    }
    
    deinit {
        print("deinit")
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
        tagSearch.resetSearchItem(from: revertSelectionTags.map({$0.name!}))
        addedTags.forEach({PersistanceManager.instance.context.delete($0)})
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

//This goes into selection tag picker presenter
extension TaskDetailViewControllerPresenter: TableViewSelectionManagerDelegate {
    func didSelectItem<T>(_ item: T) where T : Comparable, T : Hashable {
        let tag = item as! Tag
        tagSearch.removeFromSearchItem(tag.name!)
        delegate?.selectedTagsDidChange()
    }
    
    func didDeselectItem<T>(_ item: T) where T : Comparable, T : Hashable {
        let tag = item as! Tag
        tagSearch.insertToSearchItems(tag.name!)
        delegate?.selectedTagsDidChange()
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
