//
//  BulletPointTextView.swift
//  List2
//
//  Created by edan yachdav on 5/27/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class BulletPointTextView: UIView, UITextViewDelegate {
    
    private var notesTextView: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didLoad()
    }
    
    func didLoad() {
        let width = self.bounds.width
        let height = self.bounds.height
        
        notesTextView = UITextView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        notesTextView.delegate = self
        notesTextView.font = UIFont.systemFont(ofSize: 17)
    
        self.addSubview(notesTextView)
    }
    
    private var isInBulletMode = false

    func textViewDidChange(_ textView: UITextView) {
        
    }
    
    private func beginBulletMode(for textView: UITextView) {
        isInBulletMode = true
        textView.insertText("\u{2022}")
        
        
    }
    
    
    
    var previousRect = CGRect.zero
    private func lineBreakDidHappen(for textView: UITextView) -> Bool {
        let pos = textView.endOfDocument
        let currentRect = textView.caretRect(for: pos)
        
        previousRect = previousRect.origin.y == 0.0 ? currentRect : previousRect
        if(currentRect.origin.y > previousRect.origin.y){
            previousRect = CGRect.zero
            return true
        }
        previousRect = currentRect
        
        return false
    }
}
