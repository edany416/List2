//
//  TagsViewController.swift
//  List2
//
//  Created by edan yachdav on 8/12/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class TagsViewController: UIViewController {
    
    @IBOutlet weak var tagsTableView: UITableView!
    
    private var savedTags = [Tag]() {
        didSet {
            tagsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagsTableView.dataSource = self
        savedTags = PersistanceService.instance.fetchTags(given: Tag.fetchRequest())!
    }
    
    @IBAction func onTapDone(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension TagsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedTags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tagsTableView.dequeueReusableCell(withIdentifier: "TagTableViewCell", for: indexPath) as! TagTableViewCell
        let tag = savedTags[indexPath.row]
        cell.tagName.text = tag.name
        return cell
    }
    
    
}
