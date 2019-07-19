//
//  RoundedView.swift
//  List2
//
//  Created by edan yachdav on 7/17/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class RoundedView: UIView {
        
    var outlineColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewSetup()
    }
    
    private func viewSetup() {
        self.backgroundColor = .white
        self.layer.cornerRadius = self.bounds.height/2
        self.clipsToBounds = true
    }


    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        outlineColor.setStroke()
        
        let straightBorderPath = UIBezierPath()
        straightBorderPath.lineWidth = 5.0
        var startPoint = CGPoint(x: self.bounds.height/2, y: 0)
        straightBorderPath.move(to: startPoint)
        var endPoint = CGPoint(x: self.bounds.width - self.bounds.height/2, y: 0)
        straightBorderPath.addLine(to: endPoint)
        straightBorderPath.stroke()
        
        var centerPoint = CGPoint(x: self.bounds.width - self.bounds.height/2, y: self.bounds.height/2)
        let semiCirclePath = UIBezierPath()
        semiCirclePath.lineWidth = 5.0
        semiCirclePath.addArc(withCenter: centerPoint,
                              radius: self.bounds.height/2,
                              startAngle: 3*CGFloat.pi/2,
                              endAngle: CGFloat.pi/2,
                              clockwise: true)
        semiCirclePath.stroke()
        
        startPoint = CGPoint(x: self.bounds.width - self.bounds.height/2, y: self.bounds.maxY)
        endPoint = CGPoint(x: self.bounds.height/2, y: self.bounds.maxY)
        straightBorderPath.move(to: startPoint)
        straightBorderPath.addLine(to: endPoint)
        straightBorderPath.stroke()
        
        centerPoint = CGPoint(x: self.bounds.height/2, y: self.bounds.height/2)
        semiCirclePath.addArc(withCenter: centerPoint,
                              radius: self.bounds.height/2,
                              startAngle: CGFloat.pi/2,
                              endAngle: 3*CGFloat.pi/2,
                              clockwise: true)
        semiCirclePath.stroke()
    }


}
