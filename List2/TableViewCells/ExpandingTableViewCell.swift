//
//  ExpandingTableViewCell.swift
//  List2
//
//  Created by edan yachdav on 6/12/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

protocol ExpandingCellDelegate {
    func didTapCell()
}

class ExpandingTableViewCell: UITableViewCell, ShadowViewDelegate {
    @IBOutlet weak private var expandingView: UIView!
    @IBOutlet weak private var shadowView: ShadowView!
    @IBOutlet weak private var hitZone: UIView!
    
    @IBOutlet weak var taskName: UILabel!
    var row: Int = -1

    
    var isExpanded: Bool {
        get {
            return !expandingView.isHidden
        }
    }
    
    var delegate: ExpandingCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        expandingView.isHidden = true
        shadowView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hitZoneTapped))
        hitZone.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hitZoneTapped() {
        NotificationCenter.default.post(name: .didCompleteTodo, object: nil, userInfo: ["rowForCell":row])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func expand() {
        UIView.animate(withDuration: 0.3) {
            self.expandingView.alpha = 1
            self.expandingView.isHidden = false
        }
    }
    
    func contract() {
        UIView.animate(withDuration: 0.3) {
            self.expandingView.alpha = 0.99
            self.expandingView.isHidden = true
        }
    }

    func didTapView() {
        if isExpanded {
            //expandingView.fadeOut()
            contract()
        } else {
            expand()
            //expandingView.fadeIn()
        }
        delegate?.didTapCell()
    }
  
//    @IBAction func completeTodoTapped(_ sender: UIButton) {
//        NotificationCenter.default.post(name: .didCompleteTodo, object: nil, userInfo: ["tagName":taskName.text])
//    }
}

extension UIView {
    
    func fadeIn(_ duration: TimeInterval? = 0.3, onCompletion: (() -> Void)? = nil) {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration!,
                       animations: { self.alpha = 1 },
                       completion: { (value: Bool) in
                        if let complete = onCompletion { complete() }
        }
        )
    }
    
    func fadeOut(_ duration: TimeInterval? = 0.3, onCompletion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration!,
                       animations: { self.alpha = 0 },
                       completion: { (value: Bool) in
                        self.isHidden = true
                        if let complete = onCompletion { complete() }
        }
        )
    }
    
}
