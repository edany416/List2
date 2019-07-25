//
//  TagFilterCell.swift
//  List2
//
//  Created by edan yachdav on 7/25/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class TagFilterCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var underBar: UIView!
    var tapped: Bool = false {
        willSet {
            if newValue == true {
                self.underBar.backgroundColor = #colorLiteral(red: 0, green: 0.8754195553, blue: 0.5208082601, alpha: 1)
                self.title.textColor = .black
            } else {
                self.underBar.backgroundColor = .clear
                self.title.textColor = .darkGray
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.underBar.backgroundColor = .clear
        self.title.textColor = .darkGray
    }

}
