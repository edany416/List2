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
    @IBOutlet private weak var tappedBar: UIView!
    
    var tapped: Bool = false {
        willSet {
            if newValue == true {
                self.tappedBar.backgroundColor = #colorLiteral(red: 0, green: 0.8754195553, blue: 0.5208082601, alpha: 1)
                self.tagLabel.textColor = .black
            } else {
                self.tappedBar.backgroundColor = .clear
                self.tagLabel.textColor = .darkGray
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        if let bar = tappedBar, let label = tagLabel {
            self.tappedBar.backgroundColor = .clear
            self.tagLabel.textColor = .darkGray
        }
        
    }

}
