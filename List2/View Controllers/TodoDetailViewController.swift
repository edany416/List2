//
//  TodoDetailViewController.swift
//  List2
//
//  Created by edan yachdav on 5/26/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

struct Constants {
    static let INITIAL_NUM_ROWS = 4
    static let NAME_ROW = 0
    static let DATE_ROW = 1
    static let ADD_SUBTASK_ROW = 2
    static let BULLET_TRIGGER = "*"
}

class TodoDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func notesFieldTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "NotesVC Segue", sender: nil)
    }
}

extension TodoDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.INITIAL_NUM_ROWS
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        switch indexPath.row {
        case Constants.NAME_ROW:
            cell = tableView.dequeueReusableCell(withIdentifier: "Name Cell", for: indexPath)
        case Constants.DATE_ROW:
            cell = tableView.dequeueReusableCell(withIdentifier: "Date Cell", for: indexPath)
        case Constants.ADD_SUBTASK_ROW:
            cell = tableView.dequeueReusableCell(withIdentifier: "Add Subtask Cell", for: indexPath)
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "Notes Cell", for: indexPath)
        default:
            print("default for row \(indexPath.row)")
            cell = UITableViewCell()
        }
        return cell
    }
}
