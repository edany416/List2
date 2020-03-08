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
    
    private var taskTableViewDataSource: TaskTableViewDataSource?
    
//    private var tagSelectionTracker: [Tag:Bool]!
//    private var selectedTags: [String] {
//        let tags = Array(tagSelectionTracker.filter({$0.value == true}).keys)
//        return tags.map({$0.name!})
//    }
//    private var availableTags: [String] {
//        let tags = Array(tagSelectionTracker.filter({$0.value == false}).keys)
//        return tags.map({$0.name!})
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        taskTableView.dataSource = taskTableViewDataSource
    }
    
    private func loadData() {
        let tasks = (PersistanceManager.instance.fetchTasks())
        taskTableViewDataSource = TaskTableViewDataSource(from: tasks)
        
//        let tags = PersistanceManager.instance.fetchTags()
//        tagSelectionTracker = [Tag:Bool]()
//        tags.forEach({tagSelectionTracker[$0] = false})
    }
    
    private var tagPickerView: TagPickerView?
    private var taskFilter: TaskFilter?
    private var popupAnimator: ViewPopUpAnimator?
    @IBAction func didTapTagFilterButton(_ sender: UIButton) {
        if popupAnimator == nil {
            let width = view.bounds.width * 0.75
            let height = width
            tagPickerView = TagPickerView(frame: .zero)
            popupAnimator = ViewPopUpAnimator(parentView: self.view, popupView: tagPickerView!, height: height, width: width)
        }
        popupAnimator!.popup()
    }
}

