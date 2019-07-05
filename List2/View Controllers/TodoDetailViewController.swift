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
    
    private var subtaskInsertionRow = Constants.ADD_SUBTASK_ROW
    private var notesInsertionRow = Constants.INITIAL_NOTES_ROW
    private var subtasks = [Subtask]()
    
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
        let cell = tableView.cellForRow(at: IndexPath(row: notesInsertionRow, section: 0)) as! NotesCell
        cell.notesTextView.text = note
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

//Tableview implementation
extension TodoDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.INITIAL_NUM_ROWS + subtasks.count
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
                    let newSubtask = Subtask(name: subTaskName)
                    self.subtasks.append(newSubtask)
                    self.insertSubtaskCell()
                    self.view.endEditing(true)
                }
                cell = addSubTaskCell
            }
        case notesInsertionRow:
            if let noteCell = tableView.dequeueReusableCell(withIdentifier: "Notes Cell", for: indexPath) as? NotesCell {
                noteCell.onTextViewTapped {
                    let currentNote = noteCell.notesTextView.text
                    self.presentNotesViewController(note: currentNote)
                }
                cell = noteCell
            }
        default:
            if let subtaskCell = tableView.dequeueReusableCell(withIdentifier: "Subtask Cell", for: indexPath) as? SubtaskCell {
                let subtask = subtasks[indexPath.row - 3]
                subtaskCell.subtaskName.text = subtask.name
                cell = subtaskCell
            }
        }
        return cell
    }
    
    private func presentNotesViewController(note: String?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let notesVC = storyboard.instantiateViewController(withIdentifier: "Notes VC") as! NotesViewController
        notesVC.note = note
        notesVC.delegate = self
        self.present(notesVC, animated: true, completion: nil)
    }
    
    private func insertSubtaskCell() {
        tableView.beginUpdates()
        
        subtaskInsertionRow += 1
        notesInsertionRow += 1
        let subtaskIndexPath = IndexPath(row: subtaskInsertionRow, section: 0)
        tableView.insertRows(at: [subtaskIndexPath], with: .right)
        
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
                subtaskInsertionRow -= 1
                notesInsertionRow -= 1
                subtasks.remove(at: indexPath.row - 3)
                tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let cell = tableView.cellForRow(at: indexPath)
        return (cell is SubtaskCell)
    }
}


