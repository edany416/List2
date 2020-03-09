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
            let height = width
            tagPickerView = TagPickerView(frame: .zero)
            tagPickerView!.pickerTableView.delegate = tagPickerManager
            tagPickerView!.pickerTableView.dataSource = tagPickerManager
            tagPickerView!.delegate = self
            popupAnimator = ViewPopUpAnimator(parentView: self.view, popupView: tagPickerView!, height: height, width: width)
        }
        popupAnimator!.popup()
    }
}

extension TaskListViewController: TagPickerManagerDelegate {
    func didSelectItem(_ tag: String) {
        taskFilter.appendTag(withName: tag)
    }
    
    func didDeselectItem(_ tag: String) {
        taskFilter.removeTag(withName: tag)
    }
}

extension TaskListViewController: TagPickerViewDelegate {
    func didTapMainButton() {
        taskFilter.applyFilter()
        if let filteredTasks = taskFilter.appliedIntersection {
            taskTableViewDataSource.updateTaskList(Array(filteredTasks))
        } else {
            let tasks = PersistanceManager.instance.fetchTasks()
            taskTableViewDataSource.updateTaskList(tasks)
        }
        taskTableView.reloadData()
        popupAnimator!.popdown()
    }
    
    func didTapTopLeftButton() {
        taskFilter.cancelFilter()
        popupAnimator!.popdown()
    }
    
    func didTapTopRightButton() {
        print("This will be clear all")
    }
}

