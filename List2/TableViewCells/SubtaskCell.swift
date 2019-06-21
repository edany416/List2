//
//  SubtaskCell.swift
//  List2
//
//  Created by edan yachdav on 5/29/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class SubtaskCell: UITableViewCell {
    
    @IBOutlet weak var subtaskName: UILabel!
    
    private var onCompletionTapped: ()->() = { }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setOnCompletion(action: @escaping () -> ()) {
        onCompletionTapped = action
    }

}
