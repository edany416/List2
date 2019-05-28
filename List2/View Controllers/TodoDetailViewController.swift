//
//  TodoDetailViewController.swift
//  List2
//
//  Created by edan yachdav on 5/26/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class TodoDetailViewController: UIViewController, NotesViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var notesRow = Constants.INITIAL_NOTES_ROW
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func saveTapped(_ sender: UIButton) {
        
    }
    
    func userDidSaveNote(note: String) {
        let cell = tableView.cellForRow(at: IndexPath(row: notesRow, section: 0)) as! NotesCell
        cell.notesTextView.text = note
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension TodoDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.INITIAL_NUM_ROWS
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch indexPath.row {
        case Constants.NAME_ROW:
            cell = tableView.dequeueReusableCell(withIdentifier: "Name Cell", for: indexPath)
        case Constants.DATE_ROW:
            cell = tableView.dequeueReusableCell(withIdentifier: "Date Cell", for: indexPath)
        case Constants.ADD_SUBTASK_ROW:
            if let addSubTaskCell = tableView.dequeueReusableCell(withIdentifier: "Add Subtask Cell", for: indexPath) as? AddSubtaskCell {
                addSubTaskCell.onReturnKeyTapped { (subTaskName) in
                    print("Add subtask: \(subTaskName)")
                    self.view.endEditing(true)
                }
                cell = addSubTaskCell
            }
        case notesRow:
            if let noteCell = tableView.dequeueReusableCell(withIdentifier: "Notes Cell", for: indexPath) as? NotesCell {
                noteCell.onTextViewTapped {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let notesVC = storyboard.instantiateViewController(withIdentifier: "Notes VC") as! NotesViewController
                    notesVC.note = noteCell.notesTextView.text
                    notesVC.delegate = self
                    self.present(notesVC, animated: true, completion: nil)
                }
                cell = noteCell
            }
        default:
            print("default for row \(indexPath.row)")
        }
        return cell
    }
}


