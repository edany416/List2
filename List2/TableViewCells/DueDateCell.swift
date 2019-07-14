//
//  DueDateCell.swift
//  List2
//
//  Created by edan yachdav on 5/26/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class DueDateCell: UITableViewCell {
    
    @IBOutlet private weak var dueDatePicker: UIDatePicker!
    @IBOutlet private weak var dueDateLabel: UILabel!
    @IBOutlet private weak var deleteDateButton: UIButton!
    
    var dueDate: Date? {
        if dueDatePicker.isHidden {
            return nil
        } else {
            return dueDatePicker.date
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setup() {
        dueDatePicker.isHidden = true
        deleteDateButton.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dueDateLabelTapped))
        dueDateLabel.addGestureRecognizer(tapGesture)
        dueDateLabel.isUserInteractionEnabled = true
    }
    
    @objc private func dueDateLabelTapped() {
        if dueDatePicker.isHidden {
            dueDateLabel.isHidden = true
            dueDatePicker.isHidden = false
            deleteDateButton.isHidden = false
        }
    }
    
    @IBAction func deleteDateButtonTapped(_ sender: Any) {
        dueDatePicker.isHidden = true
        deleteDateButton.isHidden = true
        dueDateLabel.isHidden = false
    }
}
