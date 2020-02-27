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

    func configureCell(from model: TaskCellModel) {
        taskNameLabel.text = model.taskLabelText
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
