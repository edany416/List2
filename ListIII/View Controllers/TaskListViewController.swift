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
    @IBOutlet private weak var tagFilterButton: UIButton!
    private var tasks: [Task]!
    private var tagFilter: TagFilterView?
    private var opaqueView: UIView?
    private var hiddenTags: [Tag]!
    private var filteredTags: [Tag]!
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTableView.delegate = self
        taskTableView.dataSource = self
        loadData()
    }
    
    private func loadData() {
        tasks = PersistanceManager.instance.fetchTasks()
        hiddenTags = PersistanceManager.instance.fetchTags()
        filteredTags = [Tag]()
    }
    
    var constraints: [NSLayoutConstraint]!
    @IBAction func didTapTagFilterButton(_ sender: UIButton) {
        let width = self.view.bounds.width * 0.75
        let height = width
        let startX = (self.view.bounds.width - width)/2.0
        tagFilter = TagFilterView(frame: CGRect(x: startX, y: self.view.bounds.maxY, width: width, height: height))
        tagFilter?.delegate = self
        tagFilter!.configure(from: TagFilterViewModel(nonSelectedData: hiddenTags.map({$0.name!}),
                                                     selectedData: filteredTags.map({$0.name!})))
        tagFilter?.translatesAutoresizingMaskIntoConstraints = false
        opaqueView = UIView(frame: self.view.bounds)
        self.opaqueView?.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.2)
        self.view.addSubview(self.opaqueView!)
        self.view.addSubview(tagFilter!)
        constraints = [
            tagFilter!.heightAnchor.constraint(equalToConstant: height),
            tagFilter!.widthAnchor.constraint(equalToConstant: width),
            tagFilter!.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -1 * self.view.bounds.height*0.75),
            tagFilter!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            
        ]
        NSLayoutConstraint.activate(constraints)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension TaskListViewController: TagFilterViewDelegate {
    func didTapCancelButton() {
        constraints[2].constant = 0
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.opaqueView?.removeFromSuperview()
            self.view.layoutIfNeeded()
        }, completion: nil)
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
