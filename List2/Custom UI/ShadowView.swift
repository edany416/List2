//
//  ShadowView.swift
//  List2
//
//  Created by edan yachdav on 7/17/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewSetup()
    }
    
    private var tapped = false
    @objc private func viewTapped(gesture: UILongPressGestureRecognizer) {
        let feedbackGen = UIImpactFeedbackGenerator(style: .light)
        if gesture.state == .began {
            feedbackGen.impactOccurred()
            UIView.animate(withDuration: 0.05) {
                self.transform = CGAffineTransform(scaleX: 0.99, y: 0.99)
                self.layer.shadowRadius = 1
            }
        }
        if gesture.state == .ended {
            UIView.animate(withDuration: 0.05) {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.layer.shadowRadius = 3
            }
        }
    }
    
    private func viewSetup() {
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 3
        self.layer.cornerRadius = 3
        self.layer.shadowOpacity = 0.5
        
//        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(viewTapped(gesture:)))
//        longPressGesture.minimumPressDuration = 0
//        longPressGesture.allowableMovement = 0.0
//        self.addGestureRecognizer(longPressGesture)
    }
}
