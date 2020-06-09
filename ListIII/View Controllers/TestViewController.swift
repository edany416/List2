//
//  TestViewController.swift
//  ListIII
//
//  Created by Edan on 3/20/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
   
    var presenter: SlidingViewPresenter!
    override func viewDidLoad() {
        super.viewDidLoad()
        let slidingView = CompletedTagBadge(frame: .zero)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePopup))
        slidingView.addGestureRecognizer(tapGesture)
        slidingView.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.60).isActive = true
        //slidingView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        slidingView.backgroundColor = .green
        presenter = SlidingViewPresenter(baseView: self.view, slidingView: slidingView, fromDirection: .fromTop)
        presenter.slidingDistance = 200
    }
    
    var presented = false
    @IBAction func buttonTapped(_ sender: UIButton) {
        togglePopup()
    }
    
    @objc func togglePopup() {
        if presented {
            presenter.retract()
        } else {
            presenter.present(withOverlay: false)
        }
        
        presented = !presented
    }
    
  
}
