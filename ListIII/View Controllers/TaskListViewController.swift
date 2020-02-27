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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTableView.delegate = self
        taskTableView.dataSource = self
        loadData()
    }
    
    private func loadData() {
        tasks = PersistanceManager.instance.fetchTasks()
    }
    
    @IBAction func didTapTagFilterButton(_ sender: UIButton) {
        let blurredView = BlurredView(frame: self.view.bounds)
        let width = blurredView.bounds.width * 0.75
        let height = blurredView.bounds.height * 0.50
        let tagFilter = TagFilterView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        blurredView.addContentView(tagFilter)
        self.view.addSubview(blurredView)
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
