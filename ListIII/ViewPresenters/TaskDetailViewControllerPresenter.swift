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
    func performClearAction()
    func saveDidSucceed()
    func saveDidFailWithMessage(_ message: String)
}

class TaskDetailViewControllerPresenter {
    
    weak var delegate: TaskDetailViewControllerPresenterDelegate!
    private var task: Task?
    private var isInEditMode: Bool!
    private(set) var selectionManager: TableViewSelectionManager<Tag>!
    private var revertSelectedTags: [Tag]!
    private var revertSelectionTags: [Tag]!
    
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
    
    func save(_ task: String, _ tags: [String]) {
        if task.isEmpty && tags.isEmpty {
            delegate.saveDidFailWithMessage(SaveErrors.emptyForm.rawValue)
        } else if task.isEmpty {
            delegate.saveDidFailWithMessage(SaveErrors.emptyTaskName.rawValue)
        } else if tags.isEmpty {
            delegate.saveDidFailWithMessage(SaveErrors.emptyTags.rawValue)
        } else {
            if isInEditMode {
                //Code for updating a task
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
        let allTags = PersistanceManager.instance.fetchTags()
        selectionManager.set(selectionItems: allTags, sortOrder: nil)
        selectionManager.set(selectedItems: [])
        delegate.performClearAction()
    }
    
    func didSearch(for query: String) {
        print("query")
    }
}

extension TaskDetailViewControllerPresenter: TableViewSelectionManagerDelegate {
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
