//
//  TableViewCellViewModel.swift
//  ListIII
//
//  Created by Edan on 4/9/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewCellViewModel {
    func configure(_ cell: UITableViewCell, fromPropertyModel model: TableViewCellPropertyModel)
}
