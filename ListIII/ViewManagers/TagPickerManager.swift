//
//  TagPickerManager.swift
//  ListIII
//
//  Created by Edan on 3/8/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation
import UIKit

protocol TagPickerManagerDelegate {
    func didSelectItem(_ tag: String)
    func didDeselectItem(_ tag: String)
}

class TagPickerManager: NSObject, UITableViewDataSource, UITableViewDelegate {
    private var items: [String]
    private var selectedItems: [String]
    
    var delegate: TagPickerManagerDelegate?
    
    init(_ tagNames: [String]) {
        items = tagNames.sorted(by: < )
        selectedItems = [String]()
    }
    
    func set(selectionItems: [String]) {
        items = selectionItems.sorted(by: < )
    }
    
    func set(selectedItems: [String]) {
        self.selectedItems = selectedItems
    }
    
//    func update(tagNames items: [String]) {
//        self.items = items.sorted(by: < )
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count + selectedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagFilterCell", for: indexPath) as! TagPickerCell
        let item: String
        let pickerCellModel: TagPickerCellModel
        if indexPath.row < selectedItems.count {
            item = selectedItems[indexPath.row]
            pickerCellModel = TagPickerCellModel(tagName: item, selectionState: .selected)
            pickerCellModel.configure(cell)
        } else {
            item = items[indexPath.row - selectedItems.count]
            pickerCellModel = TagPickerCellModel(tagName: item, selectionState: .notSelected)
            pickerCellModel.configure(cell)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexOfInsertion: IndexPath
        let item: String
        if indexPath.row < selectedItems.count { //Deselection case
            item = selectedItems.remove(at: indexPath.row)
            let (rowIndex, itemsIndex) = indexForDeselectedItem(item)
            items.insert(item, at: itemsIndex)
            indexOfInsertion = IndexPath(row: rowIndex, section: 0)
            performSelectionUpdate(tableView, fromIndexPath: indexPath, toIndexPath: indexOfInsertion, completion: { finished in
                self.delegate?.didDeselectItem(item)
            })
            
        } else { //Selection Case
            item = items.remove(at: indexPath.row - selectedItems.count)
            selectedItems.append(item)
            indexOfInsertion = IndexPath(row: selectedItems.count - 1, section: 0)
            performSelectionUpdate(tableView, fromIndexPath: indexPath, toIndexPath: indexOfInsertion, completion: { finished in
                self.delegate?.didSelectItem(item)
            })
        }
    }
    
    private func performSelectionUpdate(_ tableView: UITableView, fromIndexPath: IndexPath, toIndexPath: IndexPath, completion: @escaping (Bool) -> Void) {
        tableView.performBatchUpdates({
            tableView.beginUpdates()
            tableView.deleteRows(at: [fromIndexPath], with: .right)
            tableView.insertRows(at: [toIndexPath], with: .right)
            tableView.endUpdates()
        }, completion: completion)
    }
    
    private func indexForDeselectedItem(_ item: String) -> (Int,Int) { //(RowIndex, ItemsIndex)
        let index = items.firstIndex(where: {item < $0})
        if index != nil {
            return (index! + selectedItems.count, index!)
        } else if items.isEmpty {
            return (selectedItems.count, items.count)
        } else {
            return (items.count + selectedItems.count, items.count)
        }
    }
}
