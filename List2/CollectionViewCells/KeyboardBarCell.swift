//
//  KeyboardBarCell.swift
//  List2
//
//  Created by edan yachdav on 8/11/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class KeyboardBarCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    func setSelected(_ selected: Bool) {
        if selected {
            title.textColor = .black
        } else {
            title.textColor = .white
        }
    }
}
