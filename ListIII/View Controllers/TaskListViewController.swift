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
    private var tagPickerView: TagPickerView!
    private var popupAnimator: ViewPopUpAnimator!
    private var popupViewHeight: CGFloat!
    private var itemsFilteredOutOfSearch = [String]()
    private var keepPopupAfterKeyBoardRemoval = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        taskTableView.dataSource = taskTableViewDataSource
        taskFilter = TaskFilter()
        tagPickerManager.delegate = self
        setupTagPickerView()
        popupViewHeight = self.view.bounds.height * 0.30
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    private func setupTagPickerView() {
        tagPickerView = TagPickerView()
        let width = view.bounds.width * 0.80
        let tagPickerHeight = width
        tagPickerView!.widthAnchor.constraint(equalToConstant: width).isActive = true
        tagPickerView!.heightAnchor.constraint(equalToConstant: tagPickerHeight).isActive = true
        tagPickerView!.tableViewDelegate = tagPickerManager
        tagPickerView?.tableViewDataSource = tagPickerManager
        tagPickerView!.delegate = self
    }
    
    private func loadData() {
        TestUtilities.setupDB(from: "tasks")
        let tasks = (PersistanceManager.instance.fetchTasks())
        taskTableViewDataSource = TaskTableViewDataSource(from: tasks)
        
        let tags = PersistanceManager.instance.fetchTags()
        tagPickerManager = TagPickerManager(tags.map({$0.name!}))
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if popupViewHeight <= keyboardSize.height {
                popupAnimator!.popup(withHeight: keyboardSize.height + 20)
            }
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        if keepPopupAfterKeyBoardRemoval {
            popupAnimator.popup(withHeight: popupViewHeight)
        }
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
        let avilableItems = tagPickerManager.availableItems
        var searchResults = [String]()
        
        itemsFilteredOutOfSearch.forEach( {
            if $0.hasPrefix(query) {
                searchResults.append($0)
                let toRemove = $0
                itemsFilteredOutOfSearch.removeAll(where: {$0 == toRemove})
            }
        })
        
        avilableItems.forEach({
            if $0.hasPrefix(query) {
                searchResults.append($0)
            } else {
                itemsFilteredOutOfSearch.append($0)
            }
        })
           
        tagPickerManager.set(selectionItems: searchResults)
        tagPickerView!.reloadData()
    }
    
    private func keyboardDissmisalAction() {
        popupAnimator.popdown()
        keepPopupAfterKeyBoardRemoval = false
        NotificationCenter.default.post(name: .shouldResignKeyboardNotification, object: nil)
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
        keyboardDissmisalAction()
       
    }
    
    func didTapTopLeftButton() {
        taskFilter.cancelFilter()
        let applied = taskFilter.appliedTags
        let associated = Util.associatedTags(for: applied)
        tagPickerManager.set(selectedItems: applied.map({$0.name!}))
        tagPickerManager.set(selectionItems: associated)
        tagPickerView!.reloadData()
        
        keyboardDissmisalAction()
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
        
        keyboardDissmisalAction()
    }
}

