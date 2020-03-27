//
//  ViewPopUpAnimator.swift
//  ListIII
//
//  Created by Edan on 2/27/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation
import UIKit

private enum Constants {
    static let POP_UP_WIDTH_MULTIPLIER: CGFloat = 0.75
    static let VARIABLE_CONSTRAINT_MULTIPLIER: CGFloat = 0.75
    static let INITIAL_OVERLAY_COLOR = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
    static let END_OVERLAY_COLOR = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.2)
    static let ANIMATION_DURATION_TIME = 0.2
}


class ViewPopUpAnimator {
    private var overlayView: UIView!
    private var parentView: UIView!
    private var popupView: UIView!
    private var variableConstraint: NSLayoutConstraint!
    private var popupWidth: CGFloat!
    private var popUpHeight: CGFloat!
    
    init(parentView: UIView, popupView: UIView, height: CGFloat, width: CGFloat ) {
        self.parentView = parentView
        self.popupView = popupView
        self.popupWidth = width
        self.popUpHeight = height
        setup()
    }
    
    private func setup() {
        overlayView = UIView(frame: parentView.bounds)
        overlayView.backgroundColor = Constants.INITIAL_OVERLAY_COLOR
        
        parentView.addSubview(overlayView)
        
        popupView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(self.popupView)
        variableConstraint = popupView.topAnchor.constraint(equalTo: parentView.bottomAnchor, constant: 0)
        let constraints = [
            variableConstraint!,
            popupView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            popupView.widthAnchor.constraint(equalToConstant: popupWidth),
            popupView.heightAnchor.constraint(equalToConstant: popUpHeight)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
        parentView.layoutIfNeeded()
    }
    
    func popup() {
        //variableConstraint.constant = -1 * parentView.bounds.height * Constants.VARIABLE_CONSTRAINT_MULTIPLIER
        UIView.animate(withDuration: Constants.ANIMATION_DURATION_TIME,
                        delay: 0,
                        options: .curveEaseOut,
                        animations: {
                            self.overlayView.backgroundColor = Constants.END_OVERLAY_COLOR
                            self.parentView.layoutIfNeeded()
        }, completion: nil)
    }
    
    func popdown() {
        variableConstraint.constant = 0
        UIView.animate(withDuration: Constants.ANIMATION_DURATION_TIME,
                        delay: 0,
                        options: .curveEaseOut,
                        animations: {
                            self.overlayView.backgroundColor = Constants.INITIAL_OVERLAY_COLOR
                            self.parentView.layoutIfNeeded()
        }, completion: {finished in
            self.overlayView.isUserInteractionEnabled = false
        })
    }
}
