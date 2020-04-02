//
//  TagsTextField.swift
//  ListIII
//
//  Created by Edan on 3/29/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit

class TagsTextView: UIView {
    
    private var _tags: [String] = [String]()
    var tags: [String] {
        set {
            _tags = newValue
            let concatinatedTags = _tags.joined(separator: ", ")
            textView.text = concatinatedTags
        }
        get {
            return _tags
        }
    }

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
        textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        self.addSubview(textView)
        NSLayoutConstraint.activate(textViewConstraints)
        
        tags = [String]()
    }

}
