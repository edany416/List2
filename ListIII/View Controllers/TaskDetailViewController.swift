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
    }
    
    @IBAction func didTapSave(_ sender: UIButton) {
        presenter.save(taskNameTextfield.text!, tagsTextView.tags)
    }
}

extension TaskDetailViewController: TaskDetailViewControllerPresenterDelegate {
    func shouldUpdateTagsTextField(_ tags: [String]) {
        tagsTextView.tags = tags
        popUpAnimator.popdown()
        
    }
    
    func dismissTagPickerView() {
        popUpAnimator.popdown()
    }
    
    func showTagPickerView() {
        if popUpAnimator == nil {
            popUpAnimator = ViewPopUpAnimator(parentView: self.view, popupView: tagPickerView)
        }
        popUpAnimator.popup(withHeight: self.view.bounds.height * 0.30)
    }
    
    func saveDidSucceed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveDidFailWithMessage(_ message: String) {
        print("Save failed")
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


