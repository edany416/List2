//
//  TaskDetailViewController.swift
//  ListIII
//
//  Created by Edan on 3/28/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    @IBOutlet private weak var taskNameTextfield: UITextField!
    @IBOutlet private weak var tagsTextView: TagsTextView!
    @IBOutlet private weak var titleLable: UILabel!
    private var tagPickerView: TagPickerView!
    private var popUpAnimator: ViewPopUpAnimator!
    private var presenter: TaskDetailViewControllerPresenter!
    private var shouldKeepPopupAfterKeyboardRemoval: Bool!
    private var popupIsShowing: Bool!
    
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = TaskDetailViewControllerPresenter(task, self)
        tagsTextView.delegate = presenter
        tagPickerView = TagPickerView()
        tagPickerView!.widthAnchor.constraint(equalToConstant: self.view.bounds.width*0.80).isActive = true
        tagPickerView!.heightAnchor.constraint(equalToConstant: self.view.bounds.height*0.30).isActive = true
        tagPickerView.topLeftButton.setTitle("Cancel", for: .normal)
        tagPickerView.topRightButton.setTitle("Clear", for: .normal)
        tagPickerView.delegate = presenter
        tagPickerView.tableViewDelegate = presenter.selectionManager
        tagPickerView.tableViewDataSource = presenter.selectionManager
        TextFieldManager.manager.register(self)
        taskNameTextfield.delegate = TextFieldManager.manager
        shouldKeepPopupAfterKeyboardRemoval = false
        popupIsShowing = false
    }
    
    @IBAction func didTapSave(_ sender: UIButton) {
        presenter.save(taskNameTextfield.text!, tagsTextView.tags)
    }
    
    @IBAction func didTapCancel(_ sender: UIButton) {
        TextFieldManager.manager.unregister()
        self.dismiss(animated: true, completion: nil)
    }
    
    private func dismissPopupActions() {
        shouldKeepPopupAfterKeyboardRemoval = false
        popUpAnimator.popdown()
        popupIsShowing = false
        TextFieldManager.manager.resignFirstResponder()
    }
}

extension TaskDetailViewController: TaskDetailViewControllerPresenterDelegate {
    func performApplyActionForSelectedTags(_ tags: [String]) {
        tagsTextView.tags = tags
        dismissPopupActions()
    }
    
    func performCancelAction() {
        tagPickerView.reloadData()
        dismissPopupActions()
    }
    
    func performClearAction() {
        tagPickerView.reloadData()
        tagsTextView.tags = []
        dismissPopupActions()
    }
    
    func showTagPickerView() {
        TextFieldManager.manager.resignFirstResponder()
        if popUpAnimator == nil {
            popUpAnimator = ViewPopUpAnimator(parentView: self.view, popupView: tagPickerView)
        }
        popUpAnimator.popup(withHeight: self.view.bounds.height * 0.30)
        shouldKeepPopupAfterKeyboardRemoval = true
        popupIsShowing = true
    }
    
    func saveDidSucceed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveDidFailWithMessage(_ message: String) {
        print(message)
    }
    
    func shouldConfigureForEditMode(_ editting: Bool, _ taskName: String, _ tags: [String]) {
        if editting {
            titleLable.text = taskName
        } else {
            titleLable.text = "New Todo"
        }
        taskNameTextfield.text = taskName
        tagsTextView.tags = tags
    }
}

extension TaskDetailViewController: TextFieldManagerDelegate {
    func keyboardWillShow(_ textField: UITextField, _ keyboardRect: CGRect) {
        if popupIsShowing && self.view.bounds.height * 0.30 <= keyboardRect.height {
            popUpAnimator!.popup(withHeight: keyboardRect.height + 20)
        }
    }
    
    func keyboardWillHide() {
        if popupIsShowing {
            if shouldKeepPopupAfterKeyboardRemoval {
                popUpAnimator.popup(withHeight: self.view.bounds.height * 0.30)
            } else {
                popUpAnimator.popdown()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


