////
////  TaskListViewControllerNew.swift
////  ListIII
////
////  Created by Edan on 5/3/20.
////  Copyright © 2020 Edan. All rights reserved.
////
//
//import UIKit
//
//class TaskListViewControllerNew: UIViewController {
//
//    @IBOutlet private weak var taskTableView: UITableView!
//    @IBOutlet private weak var tagsTextView: TagsTextView!
//    private var tagPickerView: TagPickerView!
//
//    private var taskListPresenter: TaskListPresenterOld!
//    private var filterTagPickerPresenter: FilterTagPickerPresenterOld!
//    private var tagsTextViewPresenter: TagsTextViewPresenterOld!
//
//    private var popupAnimator: ViewPopUpAnimator!
//    private var keepPopupAfterKeyBoardRemoval = false
//    private var popupviewHeight: CGFloat {
//        return UIScreen.main.bounds.height * 0.40
//    }
//    private var popupViewPopupHeight: CGFloat {
//        return UIScreen.main.bounds.height * 0.40
//    }
//    private var buttonTitle: String {
//        return "Apply Tags (\(filterTagPickerPresenter.tagPickerSelectionManager.selectedItems.count))"
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        taskListPresenter = TaskListPresenterOld()
//        taskListPresenter.delegate = self
//        taskTableView.dataSource = taskListPresenter.taskTableViewDataSource
//        taskTableView.delegate = self
//        tagsTextView.delegate = self
//
//        tagPickerView = TagPickerView()
//        tagPickerView.delegate = self
//        tagPickerView!.widthAnchor.constraint(equalToConstant: self.view.bounds.width*0.80).isActive = true
//        tagPickerView!.heightAnchor.constraint(equalToConstant: popupviewHeight).isActive = true
//        tagPickerView.topLeftButton.setTitle("Cancel", for: .normal)
//        tagPickerView.topRightButton.setTitle("Clear", for: .normal)
//
//        filterTagPickerPresenter = FilterTagPickerPresenterOld()
//        filterTagPickerPresenter.delegate = self
//        tagPickerView.tableViewDelegate = filterTagPickerPresenter.tagPickerSelectionManager
//        tagPickerView.tableViewDataSource = filterTagPickerPresenter.tagPickerSelectionManager
//        tagPickerView.reloadData()
//
//        tagsTextViewPresenter = TagsTextViewPresenterOld()
//        tagsTextViewPresenter.delegate = self
//
//        TextFieldManager.manager.register(self)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(handleCompleteTaskNotification(_:)), name: .didCompleteTaskNotification, object: nil)
//    }
//
//    @IBAction func didTapNewTaskButton(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let newTaskViewController = storyboard.instantiateViewController(identifier: "TaskDetailVC") as! TaskDetailViewControllerNew
//        newTaskViewController.isModalInPresentation = true
//        self.present(newTaskViewController, animated: true, completion: nil)
//    }
//
//    @objc func handleCompleteTaskNotification(_ notification: NSNotification) {
//        if let cell = notification.userInfo?["Cell"] as? UITableViewCell {
//            let indexPath = taskTableView.indexPath(for: cell)!
//            taskListPresenter.completeTask(at: indexPath.row)
//        }
//    }
//}
//
//extension TaskListViewControllerNew: TaskListPresenterDelegateOld {
//    func removeTask(at index: Int) {
//        taskTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
//    }
//
//    func updateTaskList(_ tasks: [String]) {
//        taskTableView.reloadData()
//    }
//}
//
//extension TaskListViewControllerNew: TagsTextViewDelegate {
//    func didTapTextView() {
//        if popupAnimator == nil {
//            popupAnimator = ViewPopUpAnimator(parentView: self.view, popupView: tagPickerView)
//        }
//        tagPickerView.mainButton.setTitle(buttonTitle, for: .normal)
//        keepPopupAfterKeyBoardRemoval = true
//        popupAnimator.popup(withHeight: popupViewPopupHeight)
//        tagPickerView.reloadData()
//    }
//}
//
//extension TaskListViewControllerNew: TagPickerViewDelegate {
//    func didTapMainButton() {
//        filterTagPickerPresenter.applySelection(completion: {[weak self] in
//            self?.popupAnimator.popdown()
//            self?.keepPopupAfterKeyBoardRemoval = false
//            TextFieldManager.manager.resignFirstResponder()
//        })
//    }
//
//    func didTapTopLeftButton() {
//        filterTagPickerPresenter.cancelPendingActions(completion: {[weak self] in
//            self?.popupAnimator.popdown()
//            self?.keepPopupAfterKeyBoardRemoval = false
//            TextFieldManager.manager.resignFirstResponder()
//        })
//    }
//
//    func didTapTopRightButton() {
//        filterTagPickerPresenter.clearTags(completion: {[weak self] in
//            self?.tagsTextView.tags = []
//            self?.popupAnimator.popdown()
//            self?.keepPopupAfterKeyBoardRemoval = false
//            TextFieldManager.manager.resignFirstResponder()
//        })
//    }
//
//    func didSearch(for query: String) {
//        filterTagPickerPresenter.processSearchQuery(query: query, completion: {[weak self] in
//            self?.tagPickerView.reloadData()
//        })
//    }
//}
//
//extension TaskListViewControllerNew: FilterTagPickerPresenterDelegateOld {
//    func selectedItemsDidChange() {
//        tagPickerView.mainButton.setTitle(buttonTitle, for: .normal)
//    }
//
//    func selectionItemsDidUpdate() {
//        tagPickerView.clearSearchBar()
//    }
//}
//
//extension TaskListViewControllerNew: TagsTextViewPresenterDelegateOld {
//    func shouldUpdateTags(_ tags: [String]) {
//        tagsTextView.tags = tags
//    }
//}
//
//extension TaskListViewControllerNew: TextFieldManagerDelegate {
//    func keyboardWillShow(_ textField: UITextField, _ keyboardRect: CGRect) {
//        if popupViewPopupHeight - 50 <= keyboardRect.height {
//            popupAnimator!.popup(withHeight: keyboardRect.height + 20)
//        }
//    }
//
//    func keyboardWillHide() {
//        if keepPopupAfterKeyBoardRemoval {
//            popupAnimator.popup(withHeight: popupViewPopupHeight)
//        } else {
//            //popupAnimator.popdown()
//        }
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}
//
//extension TaskListViewControllerNew: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let newTaskViewController = storyboard.instantiateViewController(identifier: "TaskDetailVC") as! TaskDetailViewControllerNew
//        newTaskViewController.isModalInPresentation = true
//        newTaskViewController.task = taskListPresenter.task(at: indexPath.row)
//        self.present(newTaskViewController, animated: true, completion: nil)
//    }
//}
