//
//  TagCollectionViewCell.swift
//  ListIII
//
//  Created by Edan on 2/26/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit

enum TagCellState {
    case selected
    case notSelected
}

struct TagCellModel {
    let tagName: String
}

class TagCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(from model: TagCellModel) {
        name.text = model.tagName
    }
    
    func setState(to state: TagCellState) {
        switch  state {
        case .selected:
            self.name.backgroundColor = Constants.MAIN_GREEN_COLOR
            self.name.textColor = .white
        case .notSelected:
            self.name.backgroundColor = .clear
            self.name.textColor = .black
        }
    }

}
