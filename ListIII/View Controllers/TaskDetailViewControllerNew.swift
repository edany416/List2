//
//  TaskDetailViewControllerNew.swift
//  ListIII
//
//  Created by Edan on 5/28/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit

class TaskDetailViewControllerNew: UIViewController {

    @IBOutlet private weak var taskNameTextField: UITextField!
    @IBOutlet private weak var tagsTextView: TagsTextView!
    @IBOutlet private weak var titleLabel: UILabel!
    private var tagPickerView: TagPickerView!
    private var popupAnimator: ViewPopUpAnimator!
    private var presenter: TaskDetailBasePresenter!
    private var shouldKeepPopupAfterKeyboardRemoval: Bool!
    private var popupIsShowing: Bool!
    private var popupviewHeight: CGFloat {
        return UIScreen.main.bounds.height * 0.40
    }
    private var popupViewPopupHeight: CGFloat {
        return UIScreen.main.bounds.height * 0.40
    }
    private var buttonTitle: String {
        //return "Select Tags (\(presenter.selectionManager.selectedItems.count))"
        return "Button title"
    }
    
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = TaskDetailBasePresenter(task)
        presenter.delegate = self
        tagsTextView.delegate = self
        tagPickerView = TagPickerView()
        tagPickerView!.widthAnchor.constraint(equalToConstant: self.view.bounds.width*0.80).isActive = true
        tagPickerView!.heightAnchor.constraint(equalToConstant: popupviewHeight).isActive = true
        tagPickerView.topLeftButton.setTitle("Cancel", for: .normal)
        tagPickerView.topRightButton.setTitle("New Tag", for: .normal)
        tagPickerView.delegate = presenter.selectionTagPickerPresenter
        tagPickerView.tableViewDelegate = presenter.selectionTagPickerPresenter.selectionManager
        tagPickerView.tableViewDataSource = presenter.selectionTagPickerPresenter.selectionManager
        shouldKeepPopupAfterKeyboardRemoval = false
        popupIsShowing = false
        TextFieldManager.manager.register(self)
    }
    
    @IBAction func didTapCancel(_ sender: UIButton) {
        TextFieldManager.manager.unregister()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSave(_ sender: UIButton) {
        presenter.save(taskNameTextField.text!, tagsTextView.tags)
    }
    
    private func dismissPopupAction() {
        shouldKeepPopupAfterKeyboardRemoval = false
        popupAnimator.popdown()
        popupIsShowing = false
        TextFieldManager.manager.resignFirstResponder()
    }
    
    deinit {
        print("Task detail new deinitialized")
    }
    
}

extension TaskDetailViewControllerNew: TaskDetailBasePresenterDelegate {
    func populateTaskNameField(_ taskName: String) {
        taskNameTextField.text = taskName
    }
    
    func updateTags(fromSelectedTags tags: [String]) {
        tagsTextView.tags = tags
    }
    
    func reloadTagPickerView() {
        tagPickerView.reloadData()
    }
    
    func saveDidSucceed() {
        TextFieldManager.manager.unregister()
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveDidFailWithError(_ error: ErrorType) {
        print(error)
    }

    func dismissTagPickerView() {
        tagPickerView.reloadData()
        dismissPopupAction()
    }
}

extension TaskDetailViewControllerNew: TagsTextViewDelegate {
    func didTapTextView() {
        TextFieldManager.manager.resignFirstResponder()
        if popupAnimator == nil {
            popupAnimator = ViewPopUpAnimator(parentView: self.view, popupView: tagPickerView)
        }
        tagPickerView.mainButton.setTitle(buttonTitle, for: .normal)
        popupAnimator.popup(withHeight: popupViewPopupHeight)
        shouldKeepPopupAfterKeyboardRemoval = true
        
    }
}

extension TaskDetailViewControllerNew: TextFieldManagerDelegate {
    func keyboardWillShow(_ textField: UITextField, _ keyboardRect: CGRect) {
        if popupIsShowing && popupViewPopupHeight - 50 <= keyboardRect.height {
            popupAnimator!.popup(withHeight: keyboardRect.height + 20)
        }
    }
    
    func keyboardWillHide() {
        if popupIsShowing {
            if shouldKeepPopupAfterKeyboardRemoval {
                popupAnimator.popup(withHeight: popupViewPopupHeight)
            } else {
                popupAnimator.popdown()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
