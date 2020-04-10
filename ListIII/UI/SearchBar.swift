//
//  SearchBar.swift
//  ListIII
//
//  Created by Edan on 3/20/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit

protocol SearchBarDelegate: class {
    func textDidChangeTo(_ query: String)
}

class SearchBar: UIView /*,UITextFieldDelegate*/ {
    private var textField: UITextField!
    private var textFieldConstraints: [NSLayoutConstraint] {
        let constraints = [
            textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5)
        ]
        return constraints
    }
    
    weak var delegate: SearchBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    @objc func textDidChange(_ textField: UITextField) {
        if let searchQuery = textField.text {
            delegate?.textDidChangeTo(searchQuery)
        }
    }
    
    func clear() {
        textField.text?.removeAll()
    }
    
    private func setup() {
        textField = UITextField(frame: .zero)
        textField.delegate = TextFieldManager.manager
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textField)
        textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        NSLayoutConstraint.activate(textFieldConstraints)
        textField.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8918974996, blue: 0.915286839, alpha: 1)
        self.backgroundColor = #colorLiteral(red: 0.8896132112, green: 0.8918974996, blue: 0.915286839, alpha: 1)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5.0
    }
}
