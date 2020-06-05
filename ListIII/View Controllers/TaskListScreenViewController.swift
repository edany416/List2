//
//  TaskListScreenViewController.swift
//  ListIII
//
//  Created by Edan on 6/3/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit

class TaskListScreenViewController: UIViewController {
    
    @IBOutlet private weak var taskListTableView: UITableView!
    @IBOutlet private weak var tagTextView: TagsTextView!
    private var tagFilterView: TagPickerView!
    
    private var presenter: TaskListScreenBasePresenter!
    
    private var popupAnimator: ViewPopUpAnimator!
    private var keepPopupAfterKeyBoardRemoval = false
    private var popupviewHeight: CGFloat {
        return UIScreen.main.bounds.height * 0.40
    }
    private var popupViewPopupHeight: CGFloat {
        return UIScreen.main.bounds.height * 0.40
    }
    private var indexOfCompletedTask: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = TaskListScreenBasePresenter()
        presenter.delegate = self
        
        taskListTableView.dataSource = presenter.taskListPresenter
        taskListTableView.delegate = presenter.taskListPresenter
        tagTextView.delegate = presenter.tagsTextViewPresenter
        
        tagFilterView = TagPickerView()
        tagFilterView.delegate = presenter.filterTagPickerPresenter
        tagFilterView.tableViewDelegate = presenter.filterTagPickerPresenter.tableViewSelectionManager
        tagFilterView.tableViewDataSource = presenter.filterTagPickerPresenter.tableViewSelectionManager
        tagFilterView!.widthAnchor.constraint(equalToConstant: self.view.bounds.width*0.80).isActive = true
        tagFilterView!.heightAnchor.constraint(equalToConstant: popupviewHeight).isActive = true
        tagFilterView.topLeftButton.setTitle("Cancel", for: .normal)
        tagFilterView.topRightButton.setTitle("Clear", for: .normal)
        
        TextFieldManager.manager.register(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(taskCompleted(_:)), name: .didCompleteTaskNotification, object: nil)
    }
    
    @objc func taskCompleted(_ notification: NSNotification) {
        if let cell = notification.userInfo?["Cell"] as? UITableViewCell {
            let index = taskListTableView.indexPath(for: cell)
            indexOfCompletedTask = index!.row
            presenter.completeTask(atIndex: index!.row)
        }
    }
    
    @IBAction func didTapNewTodoButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newTaskViewController = storyboard.instantiateViewController(identifier: "TaskDetailVC") as! TaskDetailViewControllerNew
        newTaskViewController.isModalInPresentation = true
        self.present(newTaskViewController, animated: true, completion: nil)
    }
}

extension TaskListScreenViewController: TaskListScreenBasePresenterDelegate {
    func performRowUpdatesForCompletedTask(_ deletingRow: Int, _ addingRows: [Int]) {
        tagTextView.tags = presenter.tagsTextViewPresenter.selectedTags
        let removingIndexPath = IndexPath(row: deletingRow, section: 0)
        var addingIndexPaths = [IndexPath]()
        addingRows.forEach({
            let indexPath = IndexPath(row: $0, section: 0)
            addingIndexPaths.append(indexPath)
        })
        taskListTableView.performBatchUpdates({
            taskListTableView.beginUpdates()
            taskListTableView.deleteRows(at: [removingIndexPath], with: .fade)
            taskListTableView.insertRows(at: addingIndexPaths, with: .fade)
            taskListTableView.endUpdates()
        }, completion: nil)
    }
    
   
    
    func selectionTagsDidChange() {
        tagFilterView.reloadData()
    }
    
    func selectedTagsDidChange() {
        tagFilterView.mainButton.setTitle(presenter.buttonTitle, for: .normal)
        tagFilterView.clearSearchBar()
    }
    
    func userDidClearSelectedTags() {
        tagFilterView.reloadData()
        taskListTableView.reloadData()
        tagTextView.tags = presenter.tagsTextViewPresenter.selectedTags
        popupAnimator.popdown()
        keepPopupAfterKeyBoardRemoval = false
        TextFieldManager.manager.resignFirstResponder()
    }
    
    func userDidCancelTagSelection() {
        popupAnimator.popdown()
        keepPopupAfterKeyBoardRemoval = false
        TextFieldManager.manager.resignFirstResponder()
    }
    
    func userDidApplySelectedTags() {
        taskListTableView.reloadData()
        tagTextView.tags = presenter.tagsTextViewPresenter.selectedTags
        popupAnimator.popdown()
        keepPopupAfterKeyBoardRemoval = false
        TextFieldManager.manager.resignFirstResponder()
    }
    
    func modelDidChange() {
        taskListTableView.reloadData()
        tagFilterView.reloadData()
    }
    
    func showTagFilterView() {
        if popupAnimator == nil {
            popupAnimator = ViewPopUpAnimator(parentView: self.view, popupView: tagFilterView)
        }
        tagFilterView.clearSearchBar()
        tagFilterView.mainButton.setTitle(presenter.buttonTitle, for: .normal)
        keepPopupAfterKeyBoardRemoval = true
        popupAnimator.popup(withHeight: popupViewPopupHeight)
        tagFilterView.reloadData()
    }
    
    func presentTaskDetail(forTask task: Task) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newTaskViewController = storyboard.instantiateViewController(identifier: "TaskDetailVC") as! TaskDetailViewControllerNew
        newTaskViewController.isModalInPresentation = true
        newTaskViewController.task = task
        self.present(newTaskViewController, animated: true, completion: nil)
    }
}

extension TaskListScreenViewController: TextFieldManagerDelegate {
    func keyboardWillShow(_ textField: UITextField, _ keyboardRect: CGRect) {
        if popupViewPopupHeight - 50 <= keyboardRect.height {
            popupAnimator!.popup(withHeight: keyboardRect.height + 20)
        }
    }
    
    func keyboardWillHide() {
        if keepPopupAfterKeyBoardRemoval {
            popupAnimator.popup(withHeight: popupViewPopupHeight)
        } else {
            //popupAnimator.popdown()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

