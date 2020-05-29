//
//  TaskTableViewCell.swift
//  ListIII
//
//  Created by Edan on 2/26/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit

struct TaskCellModel {
    let taskLabelText: String
}

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var taskNameLabel: UILabel!
    @IBOutlet private weak var completeTaskButton: UIButton!
    
    func configureCell(from model: TaskCellModel) {
        taskNameLabel.text = model.taskLabelText
        taskNameLabel.backgroundColor = .clear
        
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8.0
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapCompleteTodoButton(_ sender: Any) {
        NotificationCenter.default.post(name: .didCompleteTaskNotification, object: nil, userInfo: ["Cell": self])
    }
}

extension Notification.Name {
    static let didCompleteTaskNotification = Notification.Name("DidCompleteTask.edanyachdav")
}
