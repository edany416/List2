//
//  TagsTextField.swift
//  ListIII
//
//  Created by Edan on 3/29/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit

protocol TagsTextViewDelegate: class {
    func didTapTextView()
}

class TagsTextView: UIView {
    
    private var _tags: [String] = [String]()
    var tags: [String] {
        set {
            _tags = newValue
            let concatinatedTags = _tags.joined(separator: " \u{2022} ")
            textView.text = concatinatedTags
        }
        get {
            return _tags
        }
    }
    
    weak var delegate: TagsTextViewDelegate?

    private var textView: UITextView!
    private var textViewConstraints: [NSLayoutConstraint] {
        let constraints = [
            textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
        ]
        return constraints
        
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
        setupView()
        textView = UITextView()
        textView.backgroundColor = .clear
        textView.isUserInteractionEnabled = false
        textView.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        self.addSubview(textView)
        NSLayoutConstraint.activate(textViewConstraints)
        
        tags = [String]()
    }
    
    private func setupView() {
        self.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9137254902, blue: 0.9529411765, alpha: 0.4)
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapView() {
        delegate?.didTapTextView()
    }

}
