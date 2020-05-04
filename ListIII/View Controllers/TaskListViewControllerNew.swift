//
//  TaskListViewControllerNew.swift
//  ListIII
//
//  Created by Edan on 5/3/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit

class TaskListViewControllerNew: UIViewController {
    
    @IBOutlet private weak var taskTableView: UITableView!
    @IBOutlet private weak var tagsTextView: TagsTextView!
    private var tagPickerView: TagPickerView!
    
    private var taskListPresenter: TaskListPresenter!
    private var filterTagPickerPresenter: FilterTagPickerPresenter!
    
    private var popupAnimator: ViewPopUpAnimator!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskListPresenter = TaskListPresenter()
        taskTableView.dataSource = taskListPresenter.taskTableViewDataSource
        tagsTextView.delegate = self
                
        tagPickerView = TagPickerView()
        tagPickerView.delegate = self
        tagPickerView!.widthAnchor.constraint(equalToConstant: self.view.bounds.width*0.80).isActive = true
        tagPickerView!.heightAnchor.constraint(equalToConstant: self.view.bounds.height*0.30).isActive = true
        tagPickerView.topLeftButton.setTitle("Cancel", for: .normal)
        tagPickerView.topRightButton.setTitle("Clear", for: .normal)
        
        filterTagPickerPresenter = FilterTagPickerPresenter()
        tagPickerView.tableViewDelegate = filterTagPickerPresenter.tagPickerSelectionManager
        tagPickerView.tableViewDataSource = filterTagPickerPresenter.tagPickerSelectionManager
        tagPickerView.reloadData()
    }
}

extension TaskListViewControllerNew: TaskListPresenterDelegate {
    func updateTaskList(_ tasks: [String]) {
        taskTableView.reloadData()
    }
}

extension TaskListViewControllerNew: TagsTextViewDelegate {
    func didTapTextView() {
        if popupAnimator == nil {
            popupAnimator = ViewPopUpAnimator(parentView: self.view, popupView: tagPickerView)
        }
        popupAnimator.popup(withHeight: self.view.bounds.height * 0.30)
    }
}

extension TaskListViewControllerNew: TagPickerViewDelegate {
    func didTapMainButton() {
        filterTagPickerPresenter.applySelection(completion: {[weak self] in
            self?.popupAnimator.popdown()
        })
    }
    
    func didTapTopLeftButton() {
        filterTagPickerPresenter.cancelPendingActions(completion: {[weak self] in
            self?.popupAnimator.popdown()
        })
    }
    
    func didTapTopRightButton() {
        filterTagPickerPresenter.clearTags(completion: nil)
    }
    
    func didSearch(for query: String) {
        filterTagPickerPresenter.processSearchQuery(query: query, completion: nil)
    }
}

extension TaskListViewControllerNew: FilterTagPickerPresenterDelegate {
    func tagPickerShouldUpdate() {
        print("")
    }
    
    func selectionItemDidUpdate() {
        tagPickerView.clearSearchBar()
    }
}
