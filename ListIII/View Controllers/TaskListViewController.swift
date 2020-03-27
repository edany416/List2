//
//  TaskListViewController.swift
//  ListIII
//
//  Created by Edan on 2/26/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit


class TaskListViewController: UIViewController {
    
    @IBOutlet private weak var taskTableView: UITableView!
    @IBOutlet private weak var tagFilterButton: UIButton!
    @IBOutlet weak var tagsTextView: UITextView!
    
    private var taskTableViewDataSource: TaskTableViewDataSource!
    private var tagPickerManager: TagPickerManager!
    private var taskFilter: TaskFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        taskTableView.dataSource = taskTableViewDataSource
        taskFilter = TaskFilter()
        tagPickerManager.delegate = self
    }
    
    private func loadData() {
        TestUtilities.setupDB(from: "tasks")
        let tasks = (PersistanceManager.instance.fetchTasks())
        taskTableViewDataSource = TaskTableViewDataSource(from: tasks)
        
        let tags = PersistanceManager.instance.fetchTags()
        tagPickerManager = TagPickerManager(tags.map({$0.name!}))
        
    }
    
    private var tagPickerView: TagPickerView?
    private var popupAnimator: ViewPopUpAnimator?
    
    @IBAction func didTapTagFilterButton(_ sender: UIButton) {
        if popupAnimator == nil {
            let width = view.bounds.width * 0.80
            let tagPickerHeight = width
            tagPickerView = TagPickerView(frame: .zero)
            tagPickerView!.tableViewDelegate = tagPickerManager
            tagPickerView?.tableViewDataSource = tagPickerManager
            tagPickerView!.delegate = self
            
            popupAnimator = ViewPopUpAnimator(parentView: self.view, popupView: tagPickerView!, height: tagPickerHeight, width: width)
        }
        popupAnimator!.popup()
    }
}

extension TaskListViewController: TagPickerManagerDelegate {
    func didSelectItem(_ tag: String) {
        taskFilter.appendTag(withName: tag)
        let pending = taskFilter.pendingTags!
        let associatedTags = Util.associatedTags(for: pending)
        tagPickerManager.set(selectionItems: associatedTags)
        tagPickerView!.reloadData()
    }
    
    func didDeselectItem(_ tag: String) {
        taskFilter.removeTag(withName: tag)
        let pendingTags = taskFilter.pendingTags!
        let associatedTags = Util.associatedTags(for: pendingTags)
        tagPickerManager.set(selectionItems: associatedTags)
        tagPickerView!.reloadData()
    }
}

extension TaskListViewController: TagPickerViewDelegate {
    func didSearch(for query: String) {
        
    }
    
    func didTapMainButton() {
        taskFilter.applyFilter()
        if let filteredTasks = taskFilter.appliedIntersection {
            taskTableViewDataSource.updateTaskList(Array(filteredTasks))
        } else {
            let tasks = PersistanceManager.instance.fetchTasks()
            taskTableViewDataSource.updateTaskList(tasks)
        }
        taskTableView.reloadData()
        tagsTextView.text = taskFilter.appliedTags.map({$0.name!}).joined(separator: ", ")
        popupAnimator!.popdown()
    }
    
    func didTapTopLeftButton() {
        taskFilter.cancelFilter()
        let applied = taskFilter.appliedTags
        let associated = Util.associatedTags(for: applied)
        tagPickerManager.set(selectedItems: applied.map({$0.name!}))
        tagPickerManager.set(selectionItems: associated)
        tagPickerView!.reloadData()
        popupAnimator!.popdown()
    }
    
    func didTapTopRightButton() {
        taskFilter.reset()
        let allTags = PersistanceManager.instance.fetchTags()
        tagPickerManager.set(selectionItems: allTags.map({$0.name!}))
        tagPickerManager.set(selectedItems: [])
        tagPickerView!.reloadData()
        
        let tasks = PersistanceManager.instance.fetchTasks()
        taskTableViewDataSource.updateTaskList(tasks)
        taskTableView.reloadData()
        
        tagsTextView.text = ""
        
        popupAnimator!.popdown()
    }
}

