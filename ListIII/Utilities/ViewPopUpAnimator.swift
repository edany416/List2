//
//  ViewPopUpAnimator.swift
//  ListIII
//
//  Created by Edan on 2/27/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation
import UIKit

class ViewPopUpAnimator {
    private let relativeView: UIView
    private let popUpView: UIView
    private let popUpViewHeight: CGFloat
    private let popUpViewWidth: CGFloat
    private let popUpViewTopToHeightOfRelativeViewPercentage: CGFloat
    private let animationDuration: TimeInterval
    private var variableConstraint: NSLayoutConstraint!
    
    init(relativeView: UIView, popUpView: UIView, popUpViewHeight: CGFloat, popUpViewWidth: CGFloat, popUpViewTopToHeightOfRelativeViewPercentage: CGFloat, animationDuration: TimeInterval ) {
        self.relativeView = relativeView
        self.popUpView = popUpView
        self.popUpViewHeight = popUpViewHeight
        self.popUpViewWidth = popUpViewWidth
        self.popUpViewTopToHeightOfRelativeViewPercentage = popUpViewTopToHeightOfRelativeViewPercentage
        self.animationDuration = animationDuration
    }
    
    func animateUp() {
        popUpView.translatesAutoresizingMaskIntoConstraints = false
        relativeView.addSubview(popUpView)
        variableConstraint = popUpView.topAnchor.constraint(equalTo: relativeView.bottomAnchor, constant: -1 * relativeView.bounds.height * popUpViewTopToHeightOfRelativeViewPercentage)
        let constraints: [NSLayoutConstraint] = [
            popUpView.heightAnchor.constraint(equalToConstant: popUpViewHeight),
            popUpView.widthAnchor.constraint(equalToConstant: popUpViewWidth),
            popUpView.centerXAnchor.constraint(equalTo: relativeView.centerXAnchor),
            variableConstraint
        ]
        
        NSLayoutConstraint.activate(constraints)
        UIView.animate(withDuration: animationDuration,
                        delay: 0,
                        options: .curveEaseOut,
                        animations: {
                            self.relativeView.layoutIfNeeded()
        }, completion: nil)
    }
    
    func animateDown() {
        variableConstraint.constant = 0
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.relativeView.layoutIfNeeded()
        }, completion: nil)
    }
}
