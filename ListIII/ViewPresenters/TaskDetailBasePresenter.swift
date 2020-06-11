//
//  TaskDetailBasePresenter.swift
//  ListIII
//
//  Created by Edan on 5/28/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation

protocol TaskDetailBasePresenterDelegate: class {
    func saveDidSucceed()
    func saveDidFailWithError(_ error: ErrorType)
    func dismissTagPickerView()
    func updateTags(fromSelectedTags tags: [String])
    func populateTaskNameField(_ taskName: String)
    func reloadTagPickerView()
    func selectedTagsDidChange(_ selected: [Tag])
    func showAddTagForm()
    func showDuplicateTagErrorAlert()
}

class TaskDetailBasePresenter {
    
    private var tagPickerIsShowing: Bool!
    private var tagsTextViewPresenter: TagsTextViewPresenterOld!
    private(set) var selectionTagPickerPresenter: SelectionTagPickerPresenter!
    
    var task: Task?
    var newTag: String! {
        willSet {
            guard !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                delegate?.saveDidFailWithError(.invalidInput)
                return
            }
            selectionTagPickerPresenter.addTag(withName: newValue)
        }
    }
    weak var delegate: TaskDetailBasePresenterDelegate? {
        didSet {
            if task != nil {
                let tagsList = (task?.tags!.allObjects as! [Tag]).map({$0.name!})
                delegate?.populateTaskNameField(task!.taskName!)
                delegate?.updateTags(fromSelectedTags: tagsList.sorted(by: <))
            }
        }
    }
    
    init(_ task: Task?) {
        tagPickerIsShowing = false
        tagsTextViewPresenter = TagsTextViewPresenterOld()
        self.task = task
        if task == nil {
            NotificationCenter.default.addObserver(self, selector: #selector(saveDidSucceed), name: .DidCreateNewTaskNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(saveDidSucceed), name: .DidEditTaskNotification, object: nil)
        }
        selectionTagPickerPresenter = SelectionTagPickerPresenter(self.task)
        selectionTagPickerPresenter.delegate = self
    }
    
    func save(_ task: String, _ tags: [String]) {
        if task.isEmpty && tags.isEmpty {
            delegate?.saveDidFailWithError(.emptyForm)
        } else if task.isEmpty {
            delegate?.saveDidFailWithError(.emptyTaskName)
        } else if task.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            delegate?.saveDidFailWithError(.invalidInput)
        } else if tags.isEmpty {
            delegate?.saveDidFailWithError(.emptyTags)
        } else {
            if self.task != nil {
                PersistanceServices.instance.editTask(withId: self.task!.id!, taskName: task, associatedTags: tags)
            } else {
                PersistanceServices.instance.saveNewTask(task, tags)
            }
        }
    }
    
    @objc private func saveDidSucceed() {
        NotificationCenter.default.removeObserver(self)
        delegate?.saveDidSucceed()
    }
}

extension TaskDetailBasePresenter: SelectionTagPickerPresenterDelegate {
    func duplicateTagError() {
        delegate?.showDuplicateTagErrorAlert()
    }
    
    func performAddTagAction() {
        delegate?.showAddTagForm()
    }
    
    func selectedTagsDidChange(_ selected: [Tag]) {
        delegate?.selectedTagsDidChange(selected)
    }
    
    func userDidSelectTags(_ tags: [Tag]) {
        delegate?.updateTags(fromSelectedTags: tags.map({$0.name!}))
        delegate?.dismissTagPickerView()
    }
    
    func perfomCancelAction() {
        delegate?.dismissTagPickerView()
    }
    
    func userDidPerformTagSearch() {
        delegate?.reloadTagPickerView()
    }
}
