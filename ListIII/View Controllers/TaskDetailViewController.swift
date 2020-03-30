//
//  TaskDetailViewController.swift
//  ListIII
//
//  Created by Edan on 3/28/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    var taskid: String?
    
    @IBOutlet private weak var taskNameTextField: UITextField!
    @IBOutlet private weak var tagsTextView: UITextView!
    private var tagPickerView: TagPickerView!
    private var popupAnimator: ViewPopUpAnimator!
    private var popupViewHeight: CGFloat!
    private var tagPickerManager: TagPickerManager!
    private var newTagAlert: UIAlertController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tagPickerManager.delegate = self
        setupTagPickerView()
        popupViewHeight = self.view.bounds.height * 0.30
        setupAlertController()
        taskNameTextField.delegate = self
        if taskid != nil {
            //At this point populate everything as we are in an edit state
        } else {
            //Sreen is in new task mode
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(taskDidSave), name: .NSManagedObjectContextDidSave, object: nil)
        
    }
    @IBAction func didTapSave(_ sender: Any) {
        let taskName = taskNameTextField.text
        let tags = tagsTextView.text.components(separatedBy: ",")
        PersistanceManager.instance.createNewTask(taskName!, associatedTags: tags)
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        if popupAnimator == nil {
            popupAnimator = ViewPopUpAnimator(parentView: self.view, popupView: tagPickerView)
        }
        popupAnimator!.popup(withHeight: popupViewHeight)
    }
    
    @objc func taskDidSave() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func loadData() {
        let tags = PersistanceManager.instance.fetchTags()
        tagPickerManager = TagPickerManager(tags.map({$0.name!}))
    }
    
    private func setupAlertController() {
        newTagAlert = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        newTagAlert.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned newTagAlert] _ in
            let answer = newTagAlert!.textFields![0]
            self.tagPickerManager.set(selectedItems: self.tagPickerManager.selected + [answer.text!])
            answer.text = ""
            self.tagPickerView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [unowned newTagAlert] _ in
            newTagAlert!.textFields![0].text = ""
            
        }

        newTagAlert.addAction(submitAction)
        newTagAlert.addAction(cancelAction)
    }
    
    private func setupTagPickerView() {
        tagPickerView = TagPickerView()
        let width = view.bounds.width * 0.80
        let tagPickerHeight = width
        tagPickerView!.widthAnchor.constraint(equalToConstant: width).isActive = true
        tagPickerView!.heightAnchor.constraint(equalToConstant: tagPickerHeight).isActive = true
        tagPickerView!.tableViewDelegate = tagPickerManager
        tagPickerView?.tableViewDataSource = tagPickerManager
        tagPickerView.topLeftButton.setTitle("Cancel", for: .normal)
        tagPickerView.topRightButton.setTitle("Add New", for: .normal)
        tagPickerView!.delegate = self
    }
}

extension TaskDetailViewController: TagPickerManagerDelegate {
    func didSelectItem(_ tag: String) {
        print("Do this")
    }
    
    func didDeselectItem(_ tag: String) {
        print("Do this")
    }
}

extension TaskDetailViewController: TagPickerViewDelegate {
    func didTapMainButton() {
        let selected = tagPickerManager.selected
        tagsTextView.text = selected.joined(separator: ",")
        popupAnimator.popdown()
    }
    
    func didTapTopLeftButton() {
        print("Do this")
    }
    
    func didTapTopRightButton() {
        present(newTagAlert, animated: true)
    }
    
    func didSearch(for query: String) {
        print("Do this")
    }
}

extension TaskDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
}
