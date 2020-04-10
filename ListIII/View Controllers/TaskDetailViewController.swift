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
    @IBOutlet private weak var taskNameTextfield: UITextField!
    @IBOutlet private weak var tagsTextView: TagsTextView!
    @IBOutlet private weak var titleLable: UILabel!
    private var tagPickerView: TagPickerView!
    private var popupAnimator: ViewPopUpAnimator!
    private var popupViewHeight: CGFloat!
    private var tagPickerManager: TagPickerManager!
    private var newTagAlert: UIAlertController!
    private var tagSearch: SearchManager!
    private var popupIsShowing = false
    private var resetPopUpHeight = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tagPickerManager.delegate = self
        setupTagPickerView()
        popupViewHeight = self.view.bounds.height * 0.30
        setupAlertController()
        tagSearch = SearchManager(tagPickerManager.availableItems)
        tagsTextView.delegate = self
        taskNameTextfield.delegate = TextFieldManager.manager
        TextFieldManager.manager.register(self)
        titleLable.text = "New Todo"
        if taskid != nil {
            titleLable.text = ""
        }
            
        NotificationCenter.default.addObserver(self, selector: #selector(taskDidSave), name: .NSManagedObjectContextDidSave, object: nil)
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        TextFieldManager.manager.unregister()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        let taskName = taskNameTextfield.text
        let tags = tagsTextView.tags
        PersistanceManager.instance.createNewTask(taskName!, associatedTags: tags)
    }
    
    @objc func taskDidSave() {
        TextFieldManager.manager.unregister()
        self.dismiss(animated: true, completion: nil)
    }
    
    private func loadData() {
        let tags = PersistanceManager.instance.fetchTags()
        tagPickerManager = TagPickerManager()
        tagPickerManager.set(selectionItems: tags.map({$0.name!}))
    }
    
    private func setupAlertController() {
        newTagAlert = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        newTagAlert.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, unowned newTagAlert] _ in
            let answer = newTagAlert!.textFields![0]
            if answer.text != nil && !answer.text!.isEmpty  {
                self.tagPickerManager.set(selectedItems: self.tagPickerManager.selected + [answer.text!])
                answer.text = ""
                self.tagPickerView.reloadData()
            }
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
        let newSearchableItems = tagPickerManager.availableItems.filter({$0 != tag})
        tagSearch.resetSearchItem(from: newSearchableItems)
    }
    
    func didDeselectItem(_ tag: String) {
        tagSearch.insertToSearchItems(tag)
    }
}

extension TaskDetailViewController: TagPickerViewDelegate {
    func didTapMainButton() {
        let selected = tagPickerManager.selected
        tagsTextView.tags = selected
        resetPopUpHeight = false
        popupIsShowing = false
        TextFieldManager.manager.resignFirstResponder()
        popupAnimator.popdown()
    }
    
    func didTapTopLeftButton() {
        resetPopUpHeight = false
        popupIsShowing = false
        TextFieldManager.manager.resignFirstResponder()
        popupAnimator.popdown()
    }
    
    func didTapTopRightButton() {
        present(newTagAlert, animated: true)
    }
    
    func didSearch(for query: String) {
        let result = tagSearch.searchResults(forQuery: query)
        tagPickerManager.set(selectionItems: result)
        
        tagPickerView.reloadData()
    }
}

extension TaskDetailViewController: TextFieldManagerDelegate {
    func keyboardWillShow(_ textField: UITextField, _ keyboardRect: CGRect) {
        if popupIsShowing && popupViewHeight <= keyboardRect.height {
            popupAnimator!.popup(withHeight: keyboardRect.height + 20)
        }
    }
    
    func keyboardWillHide() {
        if resetPopUpHeight {
            popupAnimator!.popup(withHeight: popupViewHeight)
            resetPopUpHeight = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if popupIsShowing {
            resetPopUpHeight = true
        }
        textField.resignFirstResponder()
        return false
    }
}

extension TaskDetailViewController: TagsTextViewDelegate {
    func didTapTextView() {
        if popupAnimator == nil {
            popupAnimator = ViewPopUpAnimator(parentView: self.view, popupView: tagPickerView)
        }
        TextFieldManager.manager.resignFirstResponder()
        popupAnimator!.popup(withHeight: popupViewHeight)
        popupIsShowing = true
    } 
}
