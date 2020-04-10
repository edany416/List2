//
//  TagPickerCellViewModel.swift
//  ListIII
//
//  Created by Edan on 4/9/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation
import UIKit

struct TagPickerCellViewModel: TableViewCellViewModel {
    func configure(_ cell: UITableViewCell, fromPropertyModel model: TableViewCellPropertyModel) {
        let properties = model as! TagCellPropertyModel
        (cell as! TagPickerCell).tagName.text = properties.tagName
    }
}
