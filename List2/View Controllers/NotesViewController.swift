//
//  NotesViewController.swift
//  List2
//
//  Created by edan yachdav on 5/26/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

protocol NotesViewControllerDelegate {
    func userDidSaveNote(note: String)
}

class NotesViewController: UIViewController {
    
    @IBOutlet weak var notesTextView: UITextView!
    
    var delegate: NotesViewControllerDelegate?
    var note: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if note != nil {
            notesTextView.text = note
        }
        notesTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notesTextView.resignFirstResponder()
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(_ sender: UIButton) {
        delegate?.userDidSaveNote(note: notesTextView.text)
        self.dismiss(animated: true , completion: nil)
    }
}
