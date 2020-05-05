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
    private var tagsTextViewPresenter: TagsTextViewPresenter!
    
    private var popupAnimator: ViewPopUpAnimator!
    private var keepPopupAfterKeyBoardRemoval = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskListPresenter = TaskListPresenter()
        taskListPresenter.delegate = self
        taskTableView.dataSource = taskListPresenter.taskTableViewDataSource
        taskTableView.delegate = self
        tagsTextView.delegate = self
                
        tagPickerView = TagPickerView()
        tagPickerView.delegate = self
        tagPickerView!.widthAnchor.constraint(equalToConstant: self.view.bounds.width*0.80).isActive = true
        tagPickerView!.heightAnchor.constraint(equalToConstant: self.view.bounds.height*0.30).isActive = true
        tagPickerView.topLeftButton.setTitle("Cancel", for: .normal)
        tagPickerView.topRightButton.setTitle("Clear", for: .normal)
        
        filterTagPickerPresenter = FilterTagPickerPresenter()
        filterTagPickerPresenter.delegate = self
        tagPickerView.tableViewDelegate = filterTagPickerPresenter.tagPickerSelectionManager
        tagPickerView.tableViewDataSource = filterTagPickerPresenter.tagPickerSelectionManager
        tagPickerView.reloadData()
        
        tagsTextViewPresenter = TagsTextViewPresenter()
        tagsTextViewPresenter.delegate = self
        
        TextFieldManager.manager.register(self)
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
        keepPopupAfterKeyBoardRemoval = true
        popupAnimator.popup(withHeight: self.view.bounds.height * 0.30)
        tagPickerView.reloadData()
    }
}

extension TaskListViewControllerNew: TagPickerViewDelegate {
    func didTapMainButton() {
        filterTagPickerPresenter.applySelection(completion: {[weak self] in
            self?.popupAnimator.popdown()
            self?.keepPopupAfterKeyBoardRemoval = false
            TextFieldManager.manager.resignFirstResponder()
        })
    }
    
    func didTapTopLeftButton() {
        filterTagPickerPresenter.cancelPendingActions(completion: {[weak self] in
            self?.popupAnimator.popdown()
            self?.keepPopupAfterKeyBoardRemoval = false
            TextFieldManager.manager.resignFirstResponder()
        })
    }
    
    func didTapTopRightButton() {
        filterTagPickerPresenter.clearTags(completion: {[weak self] in
            self?.tagsTextView.tags = []
            self?.popupAnimator.popdown()
            self?.keepPopupAfterKeyBoardRemoval = false
            TextFieldManager.manager.resignFirstResponder()
        })
    }
    
    func didSearch(for query: String) {
        filterTagPickerPresenter.processSearchQuery(query: query, completion: {[weak self] in
            self?.tagPickerView.reloadData()
        })
    }
}

extension TaskListViewControllerNew: FilterTagPickerPresenterDelegate {
    func selectionItemsDidUpdate() {
        tagPickerView.clearSearchBar()
    }
}

extension TaskListViewControllerNew: TagsTextViewPresenterDelegate {
    func shouldUpdateTags(_ tags: [String]) {
        tagsTextView.tags = tags
    }
}

extension TaskListViewControllerNew: TextFieldManagerDelegate {
    func keyboardWillShow(_ textField: UITextField, _ keyboardRect: CGRect) {
        if self.view.bounds.height * 0.30 <= keyboardRect.height {
            popupAnimator!.popup(withHeight: keyboardRect.height + 20)
        }
    }
    
    func keyboardWillHide() {
        if keepPopupAfterKeyBoardRemoval {
            popupAnimator.popup(withHeight: self.view.bounds.height * 0.30)
        } else {
            //popupAnimator.popdown()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension TaskListViewControllerNew: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newTaskViewController = storyboard.instantiateViewController(identifier: "TaskDetailVC") as! TaskDetailViewController
        newTaskViewController.task = taskListPresenter.task(at: indexPath.row)
        self.present(newTaskViewController, animated: true, completion: nil)
    }
}
