//
//  BlurredView.swift
//  ListIII
//
//  Created by Edan on 2/26/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit

class BlurredView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        self.addSubview(blurEffectView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        //self.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissSelf() {
        self.removeFromSuperview()
    }
    
    func addContentView(_ view: UIView) {
        view.center = CGPoint(x: self.bounds.size.width  / 2,
                              y: self.bounds.size.height / 2)
        self.addSubview(view)
    }

}
