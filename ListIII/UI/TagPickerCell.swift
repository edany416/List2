//
//  TagFilterCell.swift
//  ListIII
//
//  Created by Edan on 3/4/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit

enum TagPickerCellSelectionState {
    case selected
    case notSelected
}

class TagPickerCell: UITableViewCell, Selectable {
    @IBOutlet private(set) var tagName: UILabel!
    func setSelectionState(to state: TagPickerCellSelectionState) {
        switch state {
        case .selected:
            self.backgroundColor = UIColor.systemGreen
            self.tagName.textColor = .white
        case .notSelected:
            self.backgroundColor = .white
            self.tagName.textColor = .black
        }
    }
    
    func selected(_ isSelected: Bool) {
        if isSelected {
            self.backgroundColor = UIColor.systemGreen
            self.tagName.textColor = .white
        } else {
            self.backgroundColor = .white
            self.tagName.textColor = .black
        }
    }
    
}

struct TagPickerCellModel {
    let tagName: String
    let selectionState: TagPickerCellSelectionState
}

extension TagPickerCellModel {
    func configure(_ cell: TagPickerCell) {
        cell.tagName.text = self.tagName
        cell.setSelectionState(to: selectionState)
    }
}

