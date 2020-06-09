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
        let slidingView = UIView(frame: .zero)
        slidingView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        slidingView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        slidingView.backgroundColor = .green
        presenter = SlidingViewPresenter(baseView: self.view, slidingView: slidingView, fromDirection: .fromBottom)
        presenter.slidingDistance = 100
    }
    
    var presented = false
    @IBAction func buttonTapped(_ sender: UIButton) {
        if presented {
            presenter.retract()
        } else {
            presenter.present()
        }
        
        presented = !presented
    }
    
  
}
