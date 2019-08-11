//
//  SuggestionsView.swift
//  List2
//
//  Created by edan yachdav on 8/10/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class SuggestionsView: UIView {
    
    @IBOutlet private var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        Bundle.main.loadNibNamed("SuggestionsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func updateSuggestions(suggestions: [String]) {
    
    }
    
}
