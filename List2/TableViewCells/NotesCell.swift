//
//  NotesCell.swift
//  List2
//
//  Created by edan yachdav on 5/27/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class NotesCell: UITableViewCell {
    
    @IBOutlet weak var notesTextView: UITextView!
    
    private var onTextViewTappedAction: () -> () = { }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func onTextViewTapped(action: @escaping ()->()) {
        onTextViewTappedAction = action
    }
    
    private func initialSetup() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(notesTextViewTapped))
        notesTextView.addGestureRecognizer(tapGesture)
    }

    @objc private func notesTextViewTapped() {
        onTextViewTappedAction()
    }
}
