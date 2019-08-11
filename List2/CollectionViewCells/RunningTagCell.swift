//
//  RunningTagCell.swift
//  List2
//
//  Created by edan yachdav on 8/7/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

protocol RunningTagCellDelegate {
    func didTapCell(_ cell: RunningTagCell)
}

class RunningTagCell: UICollectionViewCell {
    
    @IBOutlet weak var tagTitle: UILabel! {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            tagTitle.addGestureRecognizer(tapGesture)
            tagTitle.isUserInteractionEnabled = true
        }
    }
    
    var tapped: Bool = false 
    var delegate: RunningTagCellDelegate?
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc private func handleTap() {
        delegate?.didTapCell(self)
    }
    
    override func prepareForReuse() {
        print("Prepare reuse")
        delegate = nil
    }
}
