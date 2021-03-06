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
    private var completedTagBadge: CompletedTagBadge!
    
    private var presenter: TaskListScreenBasePresenter!

    private var filterViewSlidingPresenter: SlidingViewPresenter!
    private var completedTagSlidingPresenter: SlidingViewPresenter!
    private var keepPopupAfterKeyBoardRemoval = false
    private var timer: CountDownTimer!
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
        
        completedTagBadge = CompletedTagBadge()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(badgeTapped))
        completedTagBadge.addGestureRecognizer(tapGesture)
        completedTagBadge.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.60).isActive = true
        
        timer = CountDownTimer(countingDownFrom: 3)
        timer.delegate = self
        
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
    
    @objc private func badgeTapped() {
        timer.stop()
        completedTagSlidingPresenter.retract()
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
    
    func tagsCompleted() {
        if completedTagSlidingPresenter == nil {
            completedTagSlidingPresenter = SlidingViewPresenter(baseView: self.view, slidingView: completedTagBadge, fromDirection: .fromTop)
        }
        completedTagBadge.tagsLabel.text = presenter.completedTagBadgePresenter.completedTags
        completedTagSlidingPresenter.slidingDistance = self.view.safeAreaInsets.top + 10.0
        completedTagSlidingPresenter.present(withOverlay: false)
        timer.start()
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
        filterViewSlidingPresenter.retract()
        keepPopupAfterKeyBoardRemoval = false
        TextFieldManager.manager.resignFirstResponder()
    }
    
    func userDidCancelTagSelection() {
        filterViewSlidingPresenter.retract()
        keepPopupAfterKeyBoardRemoval = false
        TextFieldManager.manager.resignFirstResponder()
    }
    
    func userDidApplySelectedTags() {
        taskListTableView.reloadData()
        tagTextView.tags = presenter.tagsTextViewPresenter.selectedTags
        filterViewSlidingPresenter.retract()
        keepPopupAfterKeyBoardRemoval = false
        TextFieldManager.manager.resignFirstResponder()
    }
    
    func modelDidChange() {
        taskListTableView.reloadData()
        tagFilterView.reloadData()
    }
    
    func showTagFilterView() {
        if filterViewSlidingPresenter == nil {
            filterViewSlidingPresenter = SlidingViewPresenter(baseView: self.view, slidingView: tagFilterView, fromDirection: .fromBottom)
        }
        tagFilterView.clearSearchBar()
        tagFilterView.mainButton.setTitle(presenter.buttonTitle, for: .normal)
        keepPopupAfterKeyBoardRemoval = true
        filterViewSlidingPresenter.slidingDistance = popupViewPopupHeight
        filterViewSlidingPresenter.present(withOverlay: true)
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
            filterViewSlidingPresenter.slidingDistance = keyboardRect.height + 20
            filterViewSlidingPresenter.present(withOverlay: true)
        }
    }
    
    func keyboardWillHide() {
        if keepPopupAfterKeyBoardRemoval {
            filterViewSlidingPresenter.slidingDistance = popupViewPopupHeight
            filterViewSlidingPresenter.present(withOverlay: true)
        } else {
            //popupAnimator.popdown()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension TaskListScreenViewController: CountDownTimerDelegate {
    func countDownDidFinish() {
        completedTagSlidingPresenter.retract()
    }
}

