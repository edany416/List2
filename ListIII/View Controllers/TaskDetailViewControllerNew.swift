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
    private var tagPickerView: TagPickerView!
    private var slidingTagSelectorPresenter: SlidingViewPresenter!
    private var presenter: TaskDetailBasePresenter!
    private var shouldKeepPopupAfterKeyboardRemoval: Bool!
    private var popupIsShowing: Bool!
    private var addTagAlertController: UIAlertController!
    private var popupviewHeight: CGFloat {
        return UIScreen.main.bounds.height * 0.40
    }
    private var popupViewPopupHeight: CGFloat {
        return UIScreen.main.bounds.height * 0.40
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
        configureAddTagAlertController()
        TextFieldManager.manager.register(self)
        taskNameTextField.delegate = TextFieldManager.manager
    }
    
    private func configureAddTagAlertController() {
        addTagAlertController = UIAlertController(title: "Enter new tag", message: nil, preferredStyle: .alert)
        addTagAlertController.addTextField { (textField) in
            textField.autocapitalizationType = .words
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak addTagAlertController, weak self] _ in
            if let tagName = addTagAlertController!.textFields![0].text {
                self!.presenter.newTag = tagName
                addTagAlertController!.textFields![0].text = ""
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        addTagAlertController.addAction(addAction)
        addTagAlertController.addAction(cancelAction)
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
        slidingTagSelectorPresenter.retract()
        popupIsShowing = false
        TextFieldManager.manager.resignFirstResponder()
    }
    
    deinit {
        print("Task detail new deinitialized")
    }
    
}

extension TaskDetailViewControllerNew: TaskDetailBasePresenterDelegate {
    func showDuplicateTagErrorAlert() {
        present(AlertFactory.createAlert(ofType: .duplicateTagCreated), animated: true, completion: nil)
    }
    
    func showAddTagForm() {
        self.present(addTagAlertController, animated: true, completion: nil)
    }
    
    func selectedTagsDidChange(_ selected: [Tag]) {
        tagPickerView.mainButton.setTitle("Select Tags (\(selected.count))", for: .normal)
        tagPickerView.reloadData()
    }
    
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
        self.present(AlertFactory.createAlert(ofType: error), animated: true, completion: nil)
    }

    func dismissTagPickerView() {
        tagPickerView.reloadData()
        dismissPopupAction()
    }
}

extension TaskDetailViewControllerNew: TagsTextViewDelegate {
    func didTapTextView() {
        TextFieldManager.manager.resignFirstResponder()
        if slidingTagSelectorPresenter == nil {
            slidingTagSelectorPresenter = SlidingViewPresenter(baseView: self.view, slidingView: tagPickerView, fromDirection: .fromBottom)
        }
        tagPickerView.mainButton.setTitle("Select Tags (\(presenter.selectionTagPickerPresenter.selectionManager.selectedItems.count))", for: .normal)
        slidingTagSelectorPresenter.slidingDistance = popupViewPopupHeight
        slidingTagSelectorPresenter.present(withOverlay: true)
        shouldKeepPopupAfterKeyboardRemoval = true
        popupIsShowing = true
        
    }
}

extension TaskDetailViewControllerNew: TextFieldManagerDelegate {
    func keyboardWillShow(_ textField: UITextField, _ keyboardRect: CGRect) {
        if popupIsShowing && popupViewPopupHeight - 50 <= keyboardRect.height {
            slidingTagSelectorPresenter.slidingDistance = keyboardRect.height + 20
            slidingTagSelectorPresenter.present(withOverlay: true)
        }
    }
    
    func keyboardWillHide() {
        if popupIsShowing {
            if shouldKeepPopupAfterKeyboardRemoval {
                slidingTagSelectorPresenter.slidingDistance = popupViewPopupHeight
                slidingTagSelectorPresenter.present(withOverlay: true)
            } else {
                slidingTagSelectorPresenter.retract()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
