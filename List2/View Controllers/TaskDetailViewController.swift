//
//  TaskDetailViewController.swift
//  List2
//
//  Created by edan yachdav on 7/21/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    @IBOutlet private weak var taskNameTextField: UITextField!
    @IBOutlet private weak var tagsTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    
    var isInEditState: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(contentDidSave(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !isInEditState {
            saveButton.isEnabled = false
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func contentDidSave(_ notification: Notification) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let taskName = taskNameTextField!.text
        let tags = parseTags()
        PersistanceService.instance.saveTask(taskName: taskName!, dueDate: nil, notes: nil, tags: tags)
    }
    
    private func parseTags() -> [String]? {
        if !tagsTextField.text!.isEmpty {
            let tagsString = tagsTextField.text!
            var tagsArray = tagsString.components(separatedBy: " ")
            return tagsArray
        }
        return nil
    }
    
    @IBAction func taskNameEditingDidChange(_ sender: UITextField) {
        if sender.text != nil {
            saveButton.isEnabled = !sender.text!.isEmpty
        }
    }
}

