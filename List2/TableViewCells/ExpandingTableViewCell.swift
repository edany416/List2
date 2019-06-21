//
//  ExpandingTableViewCell.swift
//  List2
//
//  Created by edan yachdav on 6/12/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class ExpandingTableViewCell: UITableViewCell {

    @IBOutlet weak private var expandingView: UIView!
    
    var isExpanded: Bool {
        get {
            return !expandingView.isHidden
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        expandingView.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func expand() {
        UIView.animate(withDuration: 0.3) {
            self.expandingView.isHidden = false
        }
    }
    
    func contract() {
        UIView.animate(withDuration: 0.3) {
            self.expandingView.isHidden = true
        }
    }

    
  
}
