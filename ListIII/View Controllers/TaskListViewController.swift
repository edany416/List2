//
//  TaskListViewController.swift
//  ListIII
//
//  Created by Edan on 2/26/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController {
    
    @IBOutlet private weak var taskTableView: UITableView!
    @IBOutlet weak var tagsTextView: TagsTextView!
    private var taskTableViewDataSource: TaskTableViewDataSource!
    private var tagTableViewSelectionManager: TableViewSelectionManager<Tag>!
    
    
    private var taskFilter: TaskFilter!
    private var tagPickerView: TagPickerView!
    private var popupAnimator: ViewPopUpAnimator!
    private var popupViewHeight: CGFloat!
    private var keepPopupAfterKeyBoardRemoval = true
    private var tagSearch: SearchManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializations()
        connectDelegateAndDataSources()
        loadData()
        setupTagPickerView()
        TextFieldManager.manager.register(self)
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: .NSManagedObjectContextDidSave, object: nil)
    }
    
    private func initializations() {
        taskTableViewDataSource = TaskTableViewDataSource()
        taskFilter = TaskFilter()
        tagPickerView = TagPickerView()
        tagTableViewSelectionManager = TableViewSelectionManager()
    }
    
    private func connectDelegateAndDataSources() {
        taskTableView.dataSource = taskTableViewDataSource
        tagTableViewSelectionManager.delegate = self
        tagsTextView.delegate = self
        tagPickerView!.delegate = self
    }
    
    private func setupTagPickerView() {
        popupViewHeight = self.view.bounds.height * 0.30
        let width = view.bounds.width * 0.80
        let tagPickerHeight = width
        tagPickerView!.widthAnchor.constraint(equalToConstant: width).isActive = true
        tagPickerView!.heightAnchor.constraint(equalToConstant: tagPickerHeight).isActive = true
        tagPickerView!.tableViewDelegate = tagTableViewSelectionManager
        tagPickerView!.tableViewDataSource = tagTableViewSelectionManager
        
        tagPickerView.topLeftButton.setTitle("Cancel", for: .normal)
        tagPickerView.topRightButton.setTitle("Clear", for: .normal)
    }
    
    
    @objc private func loadData() {
        TestUtilities.setupDB(from: "tasks")
        let tasks = (PersistanceManager.instance.fetchTasks())
        taskTableViewDataSource.updateTaskList(tasks)
        taskTableView.reloadData()
        
        let tags = PersistanceManager.instance.fetchTags()
        tagTableViewSelectionManager.set(selectionItems: tags, sortOrder: nil)
        tagSearch = SearchManager(tags.map({$0.name!}))
    }
}

extension TaskListViewController: TagPickerViewDelegate {
    func didSearch(for query: String) {
        let searchResults = tagSearch.searchResults(forQuery: query)
        var resultTags = [Tag]()
        searchResults.forEach({resultTags.append(PersistanceManager.instance.fetchTag(named: $0)!)})
        tagTableViewSelectionManager.set(selectionItems: resultTags, sortOrder: nil)
        tagPickerView!.reloadData()
    }
    
    func didTapMainButton() {
        taskFilter.applyFilter()
        if let filteredTasks = taskFilter.appliedIntersection {
            taskTableViewDataSource.updateTaskList(Array(filteredTasks))
        } else {
            let tasks = PersistanceManager.instance.fetchTasks()
            taskTableViewDataSource.updateTaskList(tasks)
        }
        taskTableView.reloadData()
        tagsTextView.tags = taskFilter.appliedTags.map({$0.name!})
        
        popupAnimator.popdown()
        keepPopupAfterKeyBoardRemoval = false
        TextFieldManager.manager.resignFirstResponder()
    }
    
    func didTapTopLeftButton() {
        taskFilter.cancelFilter()
        let applied = taskFilter.appliedTags
        let associated = Util.associatedTags(for: applied)
        tagTableViewSelectionManager.set(selectedItems: applied)
        tagTableViewSelectionManager.set(selectionItems: associated, sortOrder: nil)
        tagPickerView!.reloadData()
        
        popupAnimator.popdown()
        keepPopupAfterKeyBoardRemoval = false
        TextFieldManager.manager.resignFirstResponder()
        
    }
    
    func didTapTopRightButton() {
        taskFilter.reset()
        let allTags = PersistanceManager.instance.fetchTags()
        tagTableViewSelectionManager.set(selectionItems: allTags, sortOrder: nil)
        tagTableViewSelectionManager.set(selectedItems: [])
        tagPickerView!.reloadData()
        
        tagSearch.resetSearchItem(from: allTags.map({$0.name!}))

        let tasks = PersistanceManager.instance.fetchTasks()
        taskTableViewDataSource.updateTaskList(tasks)
        taskTableView.reloadData()
        tagsTextView.tags = []
        popupAnimator.popdown()
        keepPopupAfterKeyBoardRemoval = false
        TextFieldManager.manager.resignFirstResponder()
        
    }
}

extension TaskListViewController: TextFieldManagerDelegate {
    func keyboardWillShow(_ textField: UITextField, _ keyboardRect: CGRect) {
        if popupViewHeight <= keyboardRect.height {
            popupAnimator!.popup(withHeight: keyboardRect.height + 20)
        }
    }
    
    func keyboardWillHide() {
        if keepPopupAfterKeyBoardRemoval {
            popupAnimator.popup(withHeight: popupViewHeight)
        } else {
            popupAnimator.popdown()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension TaskListViewController: TableViewSelectionManagerDelegate {
    func updateSelectionItemsFor<T>(item: T, selected: Bool) -> [T]? where T : Comparable, T : Hashable {
        let tag = item as! Tag
        if selected {
            taskFilter.appendTag(withName: tag.name!)
            
        } else {
            taskFilter.removeTag(withName: tag.name!)
        }
        let pendingTags = taskFilter.pendingTags!
        let associatedTags = Util.associatedTags(for: pendingTags)
        tagSearch.resetSearchItem(from: associatedTags.map({$0.name!}))
        tagPickerView.clearSearchBar()
        return associatedTags as? [T]
    }
    
    func cellDetails<T>(forItem item: T) -> TableViewCellDetails where T : Comparable, T : Hashable {
        let tag = item as! Tag
        let identifier = "TagFilterCell"
        let propertyModel = TagCellPropertyModel(tagName: tag.name!)
        let details = TableViewCellDetails(identifier: identifier, propertyModel: propertyModel, viewModel: TagPickerCellViewModel())
        return details
    }
}

extension TaskListViewController: TagsTextViewDelegate {
    func didTapTextView() {
        if popupAnimator == nil {
            popupAnimator = ViewPopUpAnimator(parentView: self.view, popupView: tagPickerView!)
        }
        keepPopupAfterKeyBoardRemoval = true
        popupAnimator!.popup(withHeight: popupViewHeight)
    }
}

