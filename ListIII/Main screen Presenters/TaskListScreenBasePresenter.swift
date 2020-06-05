//
//  TaskListScreenBasePresenter.swift
//  ListIII
//
//  Created by Edan on 6/3/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation

protocol TaskListScreenBasePresenterDelegate: class {
    func showTagFilterView()
    func presentTaskDetail(forTask task: Task)
    func modelDidChange()
    func userDidApplySelectedTags()
    func userDidCancelTagSelection()
    func userDidClearSelectedTags()
    func selectedTagsDidChange() //Called before the changes are applied
    func selectionTagsDidChange()
    func performRowUpdatesForCompletedTask(_ deletingRow: Int, _ addingRows: [Int])
}


class TaskListScreenBasePresenter {
    private(set) var filterTagPickerPresenter: FilterTagPickerPresenter!
    private(set) var taskListPresenter: TaskListPresenter!
    private(set) var tagsTextViewPresenter: TagsTextViewPresenter!
    
    weak var delegate: TaskListScreenBasePresenterDelegate?
    
    private var tasks: [Task]!
    private var tags: [Tag]!
    private var taskFilter = TaskFilter()
    private var indexOfCompletedTask: Int?
    
    private var numSelectedTags = 0
    

    
    var buttonTitle: String {
        if numSelectedTags == 0 {
            return "Show all tasks"
        } else {
            let selectedTags = filterTagPickerPresenter.tableViewSelectionManager.selectedItems
            let relatedTasks = PersistanceManager.instance.fetchTasks(for: selectedTags)
            return "Show tasks (\(relatedTasks.count))"
        }
    }
    
    init() {
        loadData()
        filterTagPickerPresenter = FilterTagPickerPresenter(fromSelectedTags: [], selectionTags: tags, allAvailableTags: tags)
        filterTagPickerPresenter.delegate = self
        taskListPresenter = TaskListPresenter(fromTasks: tasks)
        taskListPresenter.delegate = self
        tagsTextViewPresenter = TagsTextViewPresenter([])
        tagsTextViewPresenter.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(modelChanged), name: .DidCreateNewTaskNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(modelChanged), name: .DidEditTaskNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteTaskHandler), name: .DidDeleteTaskNotification, object: nil)
    }
    
    private func loadData() {
        tasks = PersistanceServices.instance.tasks
        tags = PersistanceServices.instance.tags
    }
    
    @objc func modelChanged() {
        loadData()
        filterTagPickerPresenter.set(selectedTags: [], selectionTags: tags, allAvailableTags: tags)
        taskListPresenter.update(tasks: tasks)
        delegate?.modelDidChange()
    }
    
    //2 - in task completion
    @objc func deleteTaskHandler() {
        loadData()
        updatesForCompletedTask()
    }
    
    //1 - in task completion
    func completeTask(atIndex index: Int) {
        indexOfCompletedTask = index
        let task = taskListPresenter.tasks[index]
        PersistanceServices.instance.deleteTask(taskId: task.id!)
    }
    
    private var indeciesOfInsertion = [Int]()
    private func updatesForCompletedTask() {
        let selectedTags = tagsTextViewPresenter.selectedTags
        var newSelectedTags = [Tag]()
        var tagsDidChange = false
        selectedTags.forEach({
            if let tag = PersistanceManager.instance.fetchTag(named: $0) {
                newSelectedTags.append(tag)
            } else {
                tagsDidChange = true
            }
        })
        
        if tagsDidChange {
            tagsTextViewPresenter.setTags(fromNewTags: newSelectedTags)
            let oldTaskSet = Set(taskListPresenter.tasks)
            if newSelectedTags.count == 0 {
                taskListPresenter.update(tasks: tasks)
            } else {
                taskListPresenter.update(tasks: PersistanceManager.instance.fetchTasks(for: newSelectedTags))
            }
            
            let newTasks = taskListPresenter.tasks
            for (index, item) in newTasks!.enumerated() {
                if !oldTaskSet.contains(item) {
                    indeciesOfInsertion.append(index)
                }
            }
            
            let newSelectionTags = Util.associatedTags(for: newSelectedTags)
            filterTagPickerPresenter.set(selectedTags: newSelectedTags, selectionTags: newSelectionTags, allAvailableTags: tags)
            delegate?.selectedTagsDidChange()
            
        } else {
            taskListPresenter.removeTask(atIndex: indexOfCompletedTask!)
        }
        delegate?.performRowUpdatesForCompletedTask(indexOfCompletedTask!, indeciesOfInsertion)
        indexOfCompletedTask = nil
        indeciesOfInsertion.removeAll()
        tagsDidChange = false
    }
}

extension TaskListScreenBasePresenter: FilterTagPickerPresenterDelegate {
    func didApplySelectedTags(_ tags: [Tag]) {
        var tasks: [Task]!
        if tags.isEmpty {
            tasks = self.tasks
        } else {
            tasks = PersistanceManager.instance.fetchTasks(for: tags)
        }
        taskListPresenter.update(tasks: tasks)
        tagsTextViewPresenter.setTags(fromNewTags: tags)
        delegate?.userDidApplySelectedTags()
    }
    
    func didSelectTag(_ tag: Tag) {
        numSelectedTags += 1
    }
    
    func didDeselectTag(_ tag: Tag) {
        numSelectedTags -= 1
    }
    
    func selectedTagsDidChange() {
        delegate?.selectedTagsDidChange()
    }
    
    func didCancelSelection() {
        delegate?.userDidCancelTagSelection()
    }
    
    func didPerformTagSearch() {
        
        delegate?.selectionTagsDidChange()
    }
    
    func didClearAllSelectedTags() {
        tagsTextViewPresenter.setTags(fromNewTags: [])
        taskListPresenter.update(tasks: tasks)
        numSelectedTags = 0
        delegate?.userDidClearSelectedTags()
    }
}

extension TaskListScreenBasePresenter: TaskListPresenterDelegate {
    func didSelectTask(_ task: Task) {
        delegate?.presentTaskDetail(forTask: task)
    }
}

extension TaskListScreenBasePresenter: TagsTextViewPresenterDelegate {
    func didTapTextView() {
        delegate?.showTagFilterView()
    }
}




