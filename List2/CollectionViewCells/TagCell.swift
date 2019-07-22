//
//  TagCell.swift
//  List2
//
//  Created by edan yachdav on 7/17/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {
    @IBOutlet weak var tagLabel: UILabel!
    var tapped: Bool = false {
        willSet {
            if newValue == true {
                self.contentView.backgroundColor = #colorLiteral(red: 0, green: 0.8754195553, blue: 0.5208082601, alpha: 1)
                self.tagLabel.textColor = .white
            } else {
                self.contentView.backgroundColor = .white
                self.tagLabel.textColor = .black
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
