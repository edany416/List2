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
    @IBOutlet weak var tagTextField: UITextField!
    
    private var savedTags = [Tag]() {
        didSet {
            tagsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagsTableView.dataSource = self
        let tags = PersistanceService.instance.fetchTags(given: Tag.fetchRequest())!
        savedTags = tags.filter{$0.isSaved == true}
    }
    
    @IBAction func onTapDone(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onTapAddButton(_ sender: Any) {
        
        guard let text = tagTextField.text else {
            return
        }
        let trimmed = text.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        if !trimmed.isEmpty { //Make sure text field isnt abunch of white space
            let tagName = cleanText(tagTextField.text!)
            let newTag = Tag(context: PersistanceService.instance.context)
            newTag.name = tagName
            newTag.isSaved = true
            savedTags.append(newTag)
            PersistanceService.instance.saveContext()
        }
        tagTextField.text = ""
    }
    
    private func cleanText(_ text: String) -> String {
        var textArray = text.components(separatedBy:" ")
        if textArray.first == "" {
            textArray.remove(at: 0)
        }
        if textArray.last == "" {
            textArray.remove(at: textArray.count - 1)
        }
        return textArray.joined(separator: "_")
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let tagToRemove = savedTags[indexPath.row]
            savedTags.remove(at: indexPath.row)
            PersistanceService.instance.removeSavedTag(tagToRemove)
        }
    }    
}
