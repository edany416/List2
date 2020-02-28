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
    private var tagFilterAnimator: ViewPopUpAnimator?
    
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
        opaqueView = UIView(frame: self.view.bounds)
        self.opaqueView?.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.2)
        self.view.addSubview(self.opaqueView!)
        
        tagFilterAnimator = ViewPopUpAnimator(relativeView: self.view,
                                              popUpView: tagFilter!,
                                              popUpViewHeight: height,
                                              popUpViewWidth: width,
                                              popUpViewTopToHeightOfRelativeViewPercentage: 0.75,
                                              animationDuration: 0.2)
        
        
        
        tagFilterAnimator?.animateUp()
    }
}

extension TaskListViewController: TagFilterViewDelegate {
    func didTapCancelButton() {
        opaqueView?.removeFromSuperview()
        tagFilterAnimator?.animateDown()
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
