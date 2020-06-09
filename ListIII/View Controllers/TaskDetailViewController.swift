////
////  TaskDetailViewController.swift
////  ListIII
////
////  Created by Edan on 3/28/20.
////  Copyright © 2020 Edan. All rights reserved.
////
//
//import UIKit
//
//class TaskDetailViewController: UIViewController {
//
//    @IBOutlet private weak var taskNameTextfield: UITextField!
//    @IBOutlet private weak var tagsTextView: TagsTextView!
//    @IBOutlet private weak var titleLable: UILabel!
//    private var tagPickerView: TagPickerView!
//    private var popUpAnimator: ViewPopUpAnimator!
//    private var presenter: TaskDetailViewControllerPresenter!
//    private var shouldKeepPopupAfterKeyboardRemoval: Bool!
//    private var popupIsShowing: Bool! //Use the value of the property in the base presenter
//    private var addTagAlertController: UIAlertController!
//    private var popupviewHeight: CGFloat {
//        return UIScreen.main.bounds.height * 0.40
//    }
//    private var popupViewPopupHeight: CGFloat {
//        return UIScreen.main.bounds.height * 0.40
//    }
//    private var buttonTitle: String {
//        return "Select Tags (\(presenter.selectionManager.selectedItems.count))"
//    }
//
//    var task: Task?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        presenter = TaskDetailViewControllerPresenter(task, self)
//        tagsTextView.delegate = presenter
//        tagPickerView = TagPickerView()
//        tagPickerView!.widthAnchor.constraint(equalToConstant: self.view.bounds.width*0.80).isActive = true
//        tagPickerView!.heightAnchor.constraint(equalToConstant: popupviewHeight).isActive = true
//        tagPickerView.topLeftButton.setTitle("Cancel", for: .normal)
//        tagPickerView.topRightButton.setTitle("New Tag", for: .normal)
//        tagPickerView.delegate = presenter
//        tagPickerView.tableViewDelegate = presenter.selectionManager
//        tagPickerView.tableViewDataSource = presenter.selectionManager
//        TextFieldManager.manager.register(self)
//        taskNameTextfield.delegate = TextFieldManager.manager
//        shouldKeepPopupAfterKeyboardRemoval = false
//        popupIsShowing = false
//        configureAddTagAlertController()
//    }
//
//    private func configureAddTagAlertController() {
//        addTagAlertController = UIAlertController(title: "Enter new tag", message: nil, preferredStyle: .alert)
//        addTagAlertController.addTextField(configurationHandler: nil)
//        let addAction = UIAlertAction(title: "Add", style: .default) { [unowned addTagAlertController] _ in
//            if let tag = addTagAlertController!.textFields![0].text {
//                self.presenter.addTag(tag, completion: {self.tagPickerView.reloadData()})
//            }
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
//        addTagAlertController.addAction(addAction)
//        addTagAlertController.addAction(cancelAction)
//    }
//
//    @IBAction func didTapSave(_ sender: UIButton) {
//        presenter.save(taskNameTextfield.text!, tagsTextView.tags)
//    }
//
//    @IBAction func didTapCancel(_ sender: UIButton) {
//        TextFieldManager.manager.unregister()
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    private func dismissPopupActions() {
//        shouldKeepPopupAfterKeyboardRemoval = false
//        popUpAnimator.popdown()
//        popupIsShowing = false
//        TextFieldManager.manager.resignFirstResponder()
//    }
//}
//
//extension TaskDetailViewController: TaskDetailViewControllerPresenterDelegate {
//    func duplicateTagAdded(_ tagName: String) {
//        self.present(AlertFactory.createAlert(ofType: .duplicateTagCreated), animated: true, completion: nil)
//    }
//
//    func selectedTagsDidChange() {
//        tagPickerView.mainButton.setTitle(buttonTitle, for: .normal)
//    }
//
//    func presentNewTagForm() {
//        self.present(addTagAlertController, animated: true, completion: nil)
//    }
//
//    func userPerformedTagSearch() {
//        tagPickerView.reloadData()
//    }
//
//    func performApplyActionForSelectedTags(_ tags: [String]) {
//        tagsTextView.tags = tags
//        dismissPopupActions()
//    }
//
//    func performCancelAction() {
//        tagPickerView.reloadData()
//        dismissPopupActions()
//    }
//
//    func showTagPickerView() {
//        TextFieldManager.manager.resignFirstResponder()
//        if popUpAnimator == nil {
//            popUpAnimator = ViewPopUpAnimator(parentView: self.view, popupView: tagPickerView)
//        }
//        tagPickerView.mainButton.setTitle(buttonTitle, for: .normal)
//        popUpAnimator.popup(withHeight: popupViewPopupHeight)
//        shouldKeepPopupAfterKeyboardRemoval = true
//        popupIsShowing = true
//    }
//
//    func saveDidSucceed() {
//        TextFieldManager.manager.unregister()
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func saveDidFailWithMessage(_ error: ErrorType) {
//        self.present(AlertFactory.createAlert(ofType: error), animated: true, completion: nil)
//    }
//
//    func shouldConfigureForEditMode(_ editting: Bool, _ taskName: String, _ tags: [String]) {
//        if editting {
//            titleLable.text = taskName
//        } else {
//            titleLable.text = "New Todo"
//        }
//        taskNameTextfield.text = taskName
//        tagsTextView.tags = tags
//    }
//}
//
//extension TaskDetailViewController: TextFieldManagerDelegate {
//    func keyboardWillShow(_ textField: UITextField, _ keyboardRect: CGRect) {
//        if popupIsShowing && popupViewPopupHeight - 50 <= keyboardRect.height {
//            popUpAnimator!.popup(withHeight: keyboardRect.height + 20)
//        }
//    }
//
//    func keyboardWillHide() {
//        if popupIsShowing {
//            if shouldKeepPopupAfterKeyboardRemoval {
//                popUpAnimator.popup(withHeight: popupViewPopupHeight)
//            } else {
//                popUpAnimator.popdown()
//            }
//        }
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}
//
//
