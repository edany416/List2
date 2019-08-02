//
//  ShadowView.swift
//  List2
//
//  Created by edan yachdav on 7/17/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    private var shadowReleased: CGFloat = 4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewSetup()
    }
    
    private func viewSetup() {
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = shadowReleased
        self.layer.shadowOpacity = 0.5
    }
}
