//
//  AddSubtaskCell.swift
//  List2
//
//  Created by edan yachdav on 5/26/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class AddSubtaskCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var subtaskName: UITextField!
    
    private var onKeyReturnKeyTapped: (String) -> () = {arg in }

    override func awakeFromNib() {
        super.awakeFromNib()
        subtaskName.delegate = self
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = subtaskName.text, !text.isEmpty {
            subtaskName.text = ""
            onKeyReturnKeyTapped(text)
        }
        return true
    }
    
    func onReturnKeyTapped(action: @escaping (String) -> ()) {
        onKeyReturnKeyTapped = action
    }

}
