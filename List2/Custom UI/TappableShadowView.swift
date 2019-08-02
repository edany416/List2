//
//  TappableShadowView.swift
//  List2
//
//  Created by edan yachdav on 8/2/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

protocol ShadowViewDelegate {
    func didTapView()
}


class TappableShadowView: UIView {

    var delegate: ShadowViewDelegate?
    
    private var animationDuration: TimeInterval = 0.05
    private var scaleTapped: CGFloat = 0.99
    private var scaleReleased: CGFloat = 1
    private var shadowReleased: CGFloat = 4
    private var longPressGesture: UILongPressGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewSetup()
    }
    
    private var tapped: Bool = false
    @objc private func longPressHandler(gesture: UILongPressGestureRecognizer){
        let state = gesture.state
        switch state {
        case .began:
            UIView.animate(withDuration: animationDuration) {
                self.transform = CGAffineTransform(scaleX: self.scaleTapped, y: self.scaleTapped)
                self.layer.shadowRadius = 1
            }
        case .ended:
            self.delegate!.didTapView()
            UIView.animate(withDuration: animationDuration) {
                self.transform = CGAffineTransform(scaleX: self.scaleReleased, y:self.scaleReleased)
                self.layer.shadowRadius = self.shadowReleased
            }
        default:
            break
        }
    }
    
    private func viewSetup() {
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = shadowReleased
        self.layer.shadowOpacity = 0.5
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler(gesture:)))
        longPressGesture.minimumPressDuration = 0.035
        addGestureRecognizer(longPressGesture)
        
    }

}
