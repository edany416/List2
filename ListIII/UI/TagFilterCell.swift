//
//  TagFilterCell.swift
//  ListIII
//
//  Created by Edan on 3/4/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit

struct TagFilterCellModel {
    let tagName: String
}

class TagFilterCell: UITableViewCell {

    @IBOutlet private weak var tagName: UILabel!
    
    func configureCell(from model: TagFilterCellModel) {
        tagName.text = model.tagName
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
