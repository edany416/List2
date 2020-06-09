//
//  SlidingViewPresenter.swift
//  ListIII
//
//  Created by Edan on 6/8/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation
import UIKit

private enum Constants {
    static let INITIAL_OVERLAY_COLOR = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
    static let END_OVERLAY_COLOR = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.2)
    static let ANIMATION_DURATION_TIME = 0.2
}

enum SlideInDirection {
    case fromTop
    case fromBottom
}

protocol SlidingViewPresenterDelegate: class {
    func overlayTapped()
}

class SlidingViewPresenter {
    private var overlayView: UIView!
    private var baseView: UIView!
    private var slidingView: UIView!
    private var variableConstraint: NSLayoutConstraint!
    private var slideInDirection: SlideInDirection!
    
    var slidingDistance: CGFloat!
    var overlayColor: UIColor!
    
    weak var delegate: SlidingViewPresenterDelegate?
    
    init(baseView: UIView, slidingView: UIView, fromDirection direction: SlideInDirection) {
        self.baseView = baseView
        self.slidingView = slidingView
        self.slideInDirection = direction
        setup()
    }
    
    private func setup() {
        slidingDistance = 0
        overlayColor = .clear
        
        overlayView = UIView(frame: baseView.bounds)
        overlayView.backgroundColor = overlayColor
        baseView.addSubview(overlayView)
        overlayView.isUserInteractionEnabled = false
        let tagGesture = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        overlayView.addGestureRecognizer(tagGesture)
        
        slidingView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(slidingView)
        setVariableContraint()
        let constraints = [
            variableConstraint!,
            slidingView.centerXAnchor.constraint(equalTo: baseView.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        baseView.layoutIfNeeded()
        
    }
    
    private func setVariableContraint() {
        switch slideInDirection {
        case .fromTop:
            variableConstraint = slidingView.bottomAnchor.constraint(equalTo: baseView.topAnchor, constant: -1*slidingView.bounds.height)
        case .fromBottom:
            variableConstraint = slidingView.topAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -1*slidingView.bounds.height)
        case .none:
            print("none case?")
        }
    }
    
    func present(withOverlay showOverlay: Bool){
        variableConstraint.constant = adjustedSlidingDistance()
        UIView.animate(withDuration: Constants.ANIMATION_DURATION_TIME,
                        delay: 0,
                        options: .curveEaseOut,
                        animations: {
                            if showOverlay {
                                self.overlayView.backgroundColor = Constants.END_OVERLAY_COLOR
                                self.overlayView.isUserInteractionEnabled = true
                            }
                            self.baseView.layoutIfNeeded()
        }, completion: nil)
    }
    
    func retract() {
        variableConstraint.constant = retractionDistance()
        UIView.animate(withDuration: Constants.ANIMATION_DURATION_TIME,
                        delay: 0,
                        options: .curveEaseOut,
                        animations: {
                            self.overlayView.backgroundColor = Constants.INITIAL_OVERLAY_COLOR
                            self.baseView.layoutIfNeeded()
        }, completion: nil)
        self.overlayView.isUserInteractionEnabled = false
    }
    
    private func adjustedSlidingDistance() -> CGFloat {
        switch slideInDirection! {
        case .fromTop:
            return slidingView.bounds.height + slidingDistance
        case .fromBottom:
            return -1 * (slidingView.bounds.height + slidingDistance)
        }
    }
    
    private func retractionDistance() -> CGFloat {
        switch slideInDirection! {
        case .fromTop:
            return -1*slidingView.bounds.height
        case .fromBottom:
            return slidingView.bounds.height
        }
    }
    
    @objc private func overlayTapped() {
        delegate?.overlayTapped()
    }
}
