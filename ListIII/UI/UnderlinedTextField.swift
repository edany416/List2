//
//  UnderlinedTextField.swift
//  ListIII
//
//  Created by Edan on 3/29/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit

protocol UnderlinedTextFieldDelegate: class {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
}

class UnderlinedTextField: UIView {
    
    private var textField: UITextField!
    private var textFieldConstraints: [NSLayoutConstraint] {
        let constraints = [
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
        ]
        
        return constraints
    }
    
    weak var delegate: UnderlinedTextFieldDelegate?
    var text: String? {
        return textField.text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        textField = UITextField()
        textField.backgroundColor = .clear
        textField.font = UIFont.systemFont(ofSize: 40)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = TextFieldManager.manager
        self.addSubview(textField)
        NSLayoutConstraint.activate(textFieldConstraints)
        
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.lineWidth = 3.0
        let strokeColor = #colorLiteral(red: 0.8896132112, green: 0.8918974996, blue: 0.915286839, alpha: 1)
        strokeColor.setStroke()
        path.move(to: CGPoint(x: self.bounds.minX, y: self.bounds.maxY))
        path.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY))
        path.stroke()
    }
}
