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
    @IBOutlet weak var tagsTextView: TagsTextView!
    
    private var taskTableViewDataSource: TaskTableViewDataSource!
    private var tagPickerManager: TagPickerManager!
    private var taskFilter: TaskFilter!
    private var tagPickerView: TagPickerView!
    private var popupAnimator: ViewPopUpAnimator!
    private var popupViewHeight: CGFloat!
    private var keepPopupAfterKeyBoardRemoval = true
    private var tagSearch: SearchManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        taskTableView.dataSource = taskTableViewDataSource
        taskFilter = TaskFilter()
        tagPickerManager.delegate = self
        tagSearch = SearchManager(tagPickerManager.availableItems)
        setupTagPickerView()
        popupViewHeight = self.view.bounds.height * 0.30
        TextFieldManager.manager.register(self)
    }
    
    private func setupTagPickerView() {
        tagPickerView = TagPickerView()
        let width = view.bounds.width * 0.80
        let tagPickerHeight = width
        tagPickerView!.widthAnchor.constraint(equalToConstant: width).isActive = true
        tagPickerView!.heightAnchor.constraint(equalToConstant: tagPickerHeight).isActive = true
        tagPickerView!.tableViewDelegate = tagPickerManager
        tagPickerView?.tableViewDataSource = tagPickerManager
        tagPickerView.topLeftButton.setTitle("Cancel", for: .normal)
        tagPickerView.topRightButton.setTitle("Clear", for: .normal)
        tagPickerView!.delegate = self
    }
    
    private func loadData() {
        TestUtilities.setupDB(from: "tasks")
        let tasks = (PersistanceManager.instance.fetchTasks())
        taskTableViewDataSource = TaskTableViewDataSource(from: tasks)
        
        let tags = PersistanceManager.instance.fetchTags()
        tagPickerManager = TagPickerManager(tags.map({$0.name!}))
    }
    
    @IBAction func didTapTagFilterButton(_ sender: UIButton) {
        if popupAnimator == nil {
            popupAnimator = ViewPopUpAnimator(parentView: self.view, popupView: tagPickerView!)
        }
        keepPopupAfterKeyBoardRemoval = true
        popupAnimator!.popup(withHeight: popupViewHeight)
    }
}

extension TaskListViewController: TagPickerManagerDelegate {
    func didSelectItem(_ tag: String) {
        taskFilter.appendTag(withName: tag)
        let pending = taskFilter.pendingTags!
        let associatedTags = Util.associatedTags(for: pending)
        tagSearch.resetSearchItem(from: associatedTags)
        tagPickerManager.set(selectionItems: associatedTags)
        tagPickerView.clearSearchBar()
        tagPickerView!.reloadData()
    }
    
    func didDeselectItem(_ tag: String) {
        taskFilter.removeTag(withName: tag)
        let pendingTags = taskFilter.pendingTags!
        let associatedTags = Util.associatedTags(for: pendingTags)
        tagSearch.resetSearchItem(from: associatedTags)
        tagPickerManager.set(selectionItems: associatedTags)
        tagPickerView.clearSearchBar()
        tagPickerView!.reloadData()
    }
}

extension TaskListViewController: TagPickerViewDelegate {
    func didSearch(for query: String) {
        let searchResults = tagSearch.searchResults(forQuery: query)
        tagPickerManager.set(selectionItems: searchResults)
        tagPickerView!.reloadData()
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
        tagsTextView.tags = taskFilter.appliedTags.map({$0.name!})
        
        popupAnimator.popdown()
        keepPopupAfterKeyBoardRemoval = false
        TextFieldManager.manager.resignFirstResponder()
        
       
    }
    
    func didTapTopLeftButton() {
        taskFilter.cancelFilter()
        let applied = taskFilter.appliedTags
        let associated = Util.associatedTags(for: applied)
        tagPickerManager.set(selectedItems: applied.map({$0.name!}))
        tagPickerManager.set(selectionItems: associated)
        tagPickerView!.reloadData()
        
        popupAnimator.popdown()
        keepPopupAfterKeyBoardRemoval = false
        TextFieldManager.manager.resignFirstResponder()
        
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
        tagsTextView.tags = []
        
        popupAnimator.popdown()
        keepPopupAfterKeyBoardRemoval = false
        TextFieldManager.manager.resignFirstResponder()
        
    }
}

extension TaskListViewController: TextFieldManagerDelegate {
    func keyboardWillShow(_ textField: UITextField, _ keyboardRect: CGRect) {
        if popupViewHeight <= keyboardRect.height {
            popupAnimator!.popup(withHeight: keyboardRect.height + 20)
        }
    }
    
    func keyboardWillHide() {
        if keepPopupAfterKeyBoardRemoval {
            popupAnimator.popup(withHeight: popupViewHeight)
        } else {
            popupAnimator.popdown()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

