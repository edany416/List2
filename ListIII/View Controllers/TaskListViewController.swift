//
//  TaskListViewController.swift
//  ListIII
//
//  Created by Edan on 2/26/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit

private enum Constants {
    static let POP_UP_WIDTH_MULTIPLIER: CGFloat = 0.75
    static let VARIABLE_CONSTRAINT_MULTIPLIER: CGFloat = 0.75
    static let INITIAL_OVERLAY_COLOR = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
    static let END_OVERLAY_COLOR = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.2)
    static let ANIMATION_DURATION_TIME = 0.2
}

class TaskListViewController: UIViewController {
    
    @IBOutlet private weak var taskTableView: UITableView!
    @IBOutlet private weak var tagFilterButton: UIButton!
    @IBOutlet weak var tagsTextView: UITextView!
    private var tasks: [Task]! {
        didSet {
            taskTableView.reloadData()
        }
    }
    
    private var tagSelectionTracker: [Tag:Bool]!
    private var selectedTags: [String] {
        let tags = Array(tagSelectionTracker.filter({$0.value == true}).keys)
        return tags.map({$0.name!})
    }
    private var availableTags: [String] {
        let tags = Array(tagSelectionTracker.filter({$0.value == false}).keys)
        return tags.map({$0.name!})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTableView.delegate = self
        taskTableView.dataSource = self
        loadData()
    }
    
    private func loadData() {
        tasks = PersistanceManager.instance.fetchTasks()
        let tags = PersistanceManager.instance.fetchTags()
        tagSelectionTracker = [Tag:Bool]()
        tags.forEach({tagSelectionTracker[$0] = false})
    }
    
    private var variableConstraint: NSLayoutConstraint?
    private var overlayView: UIView?
    private var tagFilterView: TagFilterView?
    private var taskFilter = TaskFilter()
    @IBAction func didTapTagFilterButton(_ sender: UIButton) {
        if tagFilterView == nil {
            let width = self.view.bounds.width * Constants.POP_UP_WIDTH_MULTIPLIER
            let height = width
            overlayView = UIView(frame: self.view.bounds)
            overlayView?.backgroundColor = Constants.INITIAL_OVERLAY_COLOR
            self.view.addSubview(overlayView!)
            tagFilterView = TagFilterView(frame: .zero)
            tagFilterView?.delegate = self
            tagFilterView!.applyButton.setTitle("Show Tasks (All)", for: .normal)
            tagFilterView!.configure(from: TagFilterViewModel(nonSelectedData: availableTags, selectedData: selectedTags))
            tagFilterView!.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(tagFilterView!)
            variableConstraint = tagFilterView?.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
            let constraints = [
                variableConstraint!,
                tagFilterView!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                tagFilterView!.widthAnchor.constraint(equalToConstant: width),
                tagFilterView!.heightAnchor.constraint(equalToConstant: height)
            ]
            NSLayoutConstraint.activate(constraints)
            self.view.layoutIfNeeded()
        }
        overlayView?.isUserInteractionEnabled = true
        animatePopUp()
    }
    
    private func animatePopUp() {
        variableConstraint?.constant = -1 * self.view.bounds.height * Constants.VARIABLE_CONSTRAINT_MULTIPLIER
        tagFilterView!.configure(from: TagFilterViewModel(nonSelectedData: availableTags,
                                                          selectedData: selectedTags))
        UIView.animate(withDuration: Constants.ANIMATION_DURATION_TIME,
                        delay: 0,
                        options: .curveEaseOut,
                        animations: {
                            self.overlayView?.backgroundColor = Constants.END_OVERLAY_COLOR
                            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    private func animatePopDown() {
        variableConstraint?.constant = 0
        UIView.animate(withDuration: Constants.ANIMATION_DURATION_TIME,
                        delay: 0,
                        options: .curveEaseOut,
                        animations: {
                            self.overlayView?.backgroundColor = Constants.INITIAL_OVERLAY_COLOR
                            self.view.layoutIfNeeded()
        }, completion: {finished in
            self.overlayView?.isUserInteractionEnabled = false
        })
    }
    
    private func updateSelectedTagData() {
        
    }
}

extension TaskListViewController: TagFilterViewDelegate {
    
    func didSelectItem(with tagName: String) {
        let result = taskFilter.appendTag(withName: tagName)
        tagFilterView?.applyButton.setTitle("Show Tasks (\(result))", for: .normal)
    }
    
    func didDeselectItem(with tagName: String) {
        if let result = taskFilter.removeTag(withName: tagName) {
            tagFilterView?.applyButton.setTitle("Show Tasks (\(result))", for: .normal)
        } else {
            tagFilterView?.applyButton.setTitle("Show Tasks (All)", for: .normal)
        }
    }
    
    func didTapApply() {
        if let filteredTasks = taskFilter.apply() {
            tasks = filteredTasks
        } else {
            tasks = PersistanceManager.instance.fetchTasks()
        }
        let appliedTags = taskFilter.appliedTags
        tagSelectionTracker.keys.forEach { tagSelectionTracker[$0] = appliedTags.contains($0)}
        tagsTextView.text = appliedTags.map({$0.name!}).joined(separator: " ")
        animatePopDown()
    }
    
    func didTapCancelButton() {
        taskFilter.cancel()
        animatePopDown()
    }
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskTableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        let task = tasks[indexPath.row]
        cell.configureCell(from: TaskCellModel(taskLabelText: task.taskName!))
        return cell
    }
    
    
}
