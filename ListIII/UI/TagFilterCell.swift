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

enum FilterCellSelectionState {
    case selected
    case notSelected
}

class TagFilterCell: UITableViewCell {

    @IBOutlet private weak var tagName: UILabel!
    
    func configureCell(from model: TagFilterCellModel) {
        tagName.text = model.tagName
        tagName.backgroundColor = .clear
    }
    
    func setSelectionState(to state: FilterCellSelectionState) {
        switch state {
        case .selected:
            self.backgroundColor = GlobalConstants.MAIN_GREEN_COLOR
            self.tagName.textColor = .white
        case .notSelected:
            self.backgroundColor = .white
            self.tagName.textColor = .black
        }
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
