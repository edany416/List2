//
//  TagTableViewCell.swift
//  List2
//
//  Created by edan yachdav on 8/12/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class TagTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tagName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
