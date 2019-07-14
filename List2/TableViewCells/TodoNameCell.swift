//
//  TodoNameCell.swift
//  List2
//
//  Created by edan yachdav on 5/26/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

protocol TaskNameCellDelegate {
    func taskNameTextFieldTextChanged(_ text: String?)
}

class TodoNameCell: UITableViewCell {
    
    @IBOutlet weak var taskNameTextField: UITextField!
    var delegate: TaskNameCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction private func taskNameTextfieldTextChanged(_ sender: UITextField) {
        if delegate != nil {
            delegate?.taskNameTextFieldTextChanged(sender.text)
        }
    }
}
