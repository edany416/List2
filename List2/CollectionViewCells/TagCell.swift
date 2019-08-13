//
//  TagFilterCell.swift
//  List2
//
//  Created by edan yachdav on 7/25/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var underBar: UIView!
    var tapped: Bool = false {
        willSet {
            if newValue == true {
                self.underBar.backgroundColor = .clear
                self.title.textColor = .black
            } else {
                self.underBar.backgroundColor = .clear
                self.title.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.underBar.backgroundColor = .clear
        self.title.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }

}
