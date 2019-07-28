//
//  ShadowView.swift
//  List2
//
//  Created by edan yachdav on 7/17/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

protocol ShadowViewDelegate {
    func didTapView()
}

class ShadowView: UIView {
    
    var delegate: ShadowViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewSetup()
    }
    
    private var tapped: Bool = false
    @objc private func viewTapped(gesture: UITapGestureRecognizer) {
        let feedbackGen = UIImpactFeedbackGenerator(style: .light)
        if !tapped {
            feedbackGen.impactOccurred()
            UIView.animate(withDuration: 0.05) {
                self.transform = CGAffineTransform(scaleX: 0.99, y: 0.99)
                self.layer.shadowRadius = 1
            }
            tapped = true
        } else {
            self.backgroundColor = .white
            UIView.animate(withDuration: 0.05) {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.layer.shadowRadius = 3
            }
            tapped = false
        }
    }
    
    @objc private func longPressHandler(gesture: UILongPressGestureRecognizer){
        let state = gesture.state
        switch state {
        case .began:
            UIView.animate(withDuration: 0.05) {
                self.transform = CGAffineTransform(scaleX: 0.99, y: 0.99)
                self.layer.shadowRadius = 1
            }
        case .ended:
            self.delegate!.didTapView()
            UIView.animate(withDuration: 0.05) {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.layer.shadowRadius = 3
            }
        default:
            break
        }
    }
    
    private func viewSetup() {
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 3
        //self.layer.cornerRadius = 3
        self.layer.shadowOpacity = 0.5
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gesture:)))
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler(gesture:)))
        longTapGesture.minimumPressDuration = 0.035
        addGestureRecognizer(longTapGesture)
    }
}
