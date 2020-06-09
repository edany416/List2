//
//  CompletedTagBadge.swift
//  ListIII
//
//  Created by Edan on 6/9/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation
import UIKit

class CompletedTagBadge: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var tagsLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        Bundle.main.loadNibNamed("CompletedTagBadge", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.backgroundColor = .clear
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 15.0
    }
}


