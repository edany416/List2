//
//  TodoDetailViewController.swift
//  List2
//
//  Created by edan yachdav on 5/26/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class TodoDetailViewController: UIViewController, NotesViewControllerDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var saveButton: UIButton!
    
    private var subtaskInsertionRow = Constants.ADD_SUBTASK_ROW
    private var notesInsertionRow = Constants.INITIAL_NOTES_ROW
    private var subtasks = [Subtask]()
    private var taskDueDate: Date?
    
    var isInEditState: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        saveButton.isEnabled = isInEditState
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(contentDidSave(_:)),
                                               name: Notification.Name.NSManagedObjectContextDidSave,
                                               object: nil)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func saveTapped(_ sender: UIButton) {
        
        let nameCell = tableView.cellForRow(at: IndexPath(row: Constants.NAME_ROW, section: 0)) as! TodoNameCell
        let taskName = nameCell.taskNameTextField.text!
        
        let dueDateCell = tableView.cellForRow(at: IndexPath(row: Constants.DATE_ROW, section: 0)) as! DueDateCell
        let dueDate = dueDateCell.dueDate
        
        let notesCell = tableView.cellForRow(at: IndexPath(row: notesInsertionRow, section: 0)) as! NotesCell
        var notes: String?
        if !notesCell.notesTextView.text.isEmpty {
            notes = notesCell.notesTextView.text
        }
        
        PersistanceService.instance.saveTask(taskName: taskName, dueDate: dueDate, notes: notes)
    }
    
    func userDidSaveNote(note: String) {
        let cell = tableView.cellForRow(at: IndexPath(row: notesInsertionRow, section: 0)) as! NotesCell
        cell.notesTextView.text = note
    }
    
    @objc func contentDidSave(_ notification: Notification) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

//TaskNameCellDelegate
extension TodoDetailViewController: TaskNameCellDelegate {
    func taskNameTextFieldTextChanged(_ text: String?) {
        if text != nil {
            saveButton.isEnabled = !text!.isEmpty
        }
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
            if let taskNameCell = tableView.dequeueReusableCell(withIdentifier: "Name Cell", for: indexPath) as? TodoNameCell {
                taskNameCell.delegate = self
                cell = taskNameCell
            }
            
        case Constants.DATE_ROW:
            if let dueDateCell = tableView.dequeueReusableCell(withIdentifier: "Date Cell", for: indexPath) as? DueDateCell {
                cell = dueDateCell
            }
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


