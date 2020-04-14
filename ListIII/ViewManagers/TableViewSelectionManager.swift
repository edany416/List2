//
//  TableViewSelectionManager.swift
//  ListIII
//
//  Created by Edan on 4/9/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation
import UIKit

struct TableViewCellDetails {
    let identifier: String
    let propertyModel: TableViewCellPropertyModel
    let viewModel: TableViewCellViewModel
}

protocol TableViewSelectionManagerDelegate: class {
    func updateSelectionItemsFor(item: AnyHashable, selected: Bool) -> [AnyHashable]?
    func didSelect(item: AnyHashable)
    func didDeselectItem(item: AnyHashable)
    func cellDetails(forItem item: AnyHashable) -> TableViewCellDetails
}

protocol Selectable {
    func selected(_ isSelected: Bool)
}

class TableViewSelectionManager: NSObject, UITableViewDataSource, UITableViewDelegate {
    private(set) var selectionItems: [AnyHashable]
    private(set) var selectedItems: [AnyHashable]
    
    weak var delegate: TableViewSelectionManagerDelegate?
    
    override init() {
        selectionItems = [AnyHashable]()
        selectedItems = [AnyHashable]()
    }
    
    func set(selectionItems: [AnyHashable], sortOrder: ((AnyHashable, AnyHashable) -> Bool)?) {
        self.selectionItems = selectionItems
        
        if sortOrder != nil {
            self.selectionItems = self.selectionItems.sorted(by: sortOrder!)
        }
    }
    
    func set(selectedItems: [AnyHashable]) {
        self.selectedItems = selectedItems
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numRowsInSection = Int()
        switch section {
        case 0:
            numRowsInSection = selectedItems.count
        case 1:
            numRowsInSection = selectionItems.count
        default:
            return 0
        }
        return numRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        var selected = Bool()
        if delegate != nil {
            var cellDetails: TableViewCellDetails!
            if indexPath.section == 0 {
                cellDetails = delegate!.cellDetails(forItem: selectedItems[indexPath.row])
                selected = true
            } else if indexPath.section == 1 {
                cellDetails = delegate!.cellDetails(forItem: selectionItems[indexPath.row])
                selected = false
            }
            cell = tableView.dequeueReusableCell(withIdentifier: cellDetails.identifier, for: indexPath)
            cellDetails.viewModel.configure(cell, fromPropertyModel: cellDetails.propertyModel)
            if cell is Selectable {
                (cell as! Selectable).selected(selected)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item: AnyHashable!
        if indexPath.section == 1 { //Selection case
            item = selectionItems.remove(at: indexPath.row)
            selectedItems.insert(item, at: selectedItems.count)
            let indexOfInsertion = IndexPath(row: selectedItems.count-1, section: 0)
            let indexOfDeletion = IndexPath(row: indexPath.row, section: 1)
            performRowUpdates(tableView, insertionUpdates: [indexOfInsertion], deletionUpdates: [indexOfDeletion], deletionAnimation: .right, insertionAnimation: .right) { [unowned self] (finished) in
                if let updatedList = self.delegate?.updateSelectionItemsFor(item: item, selected: true) {
                    self.updateList(from: Set(updatedList), tableView)
                }
            }
        } else {
            item = selectedItems.remove(at: indexPath.row)
            selectionItems.insert(item, at: selectionItems.count)
            let indexOfInsertion = IndexPath(row: selectionItems.count-1, section: 1)
            let indexOfDeletion = IndexPath(row: indexPath.row, section: 0)
            performRowUpdates(tableView, insertionUpdates: [indexOfInsertion], deletionUpdates: [indexOfDeletion], deletionAnimation: .right, insertionAnimation: .right) { [unowned self] (finished) in
                if let updatedList = self.delegate?.updateSelectionItemsFor(item: item, selected: false) {
                    self.updateList(from: Set(updatedList), tableView)
                }
            }
        }
    }
        
    private func updateList(from list: Set<AnyHashable>, _ tableView: UITableView) {
        var updatedSet = list
        var deletionIndexPaths = [IndexPath]()
        var newSelectionItems = [AnyHashable]()
        for (index, item) in selectionItems.enumerated() {
            if updatedSet.contains(item) {
                updatedSet.remove(item)
                newSelectionItems.append(item)
            } else {
                let rowToDelete = IndexPath(row: index, section: 1)
                deletionIndexPaths.append(rowToDelete)
            }
        }
        selectionItems = newSelectionItems + Array(updatedSet)
        var insertionIndexPaths = [IndexPath]()
        for (index, item) in selectionItems.enumerated() {
            if updatedSet.contains(item) {
                let rowToInsert = IndexPath(row: index, section: 1)
                insertionIndexPaths.append(rowToInsert)
            }
        }
        performRowUpdates(tableView, insertionUpdates: insertionIndexPaths, deletionUpdates: deletionIndexPaths, deletionAnimation: .fade, insertionAnimation: .fade, completion: nil)
    }
    
    private func performRowUpdates(_ tableView: UITableView, insertionUpdates insertionIndexPaths: [IndexPath], deletionUpdates deletionIndexPaths: [IndexPath], deletionAnimation: UITableView.RowAnimation, insertionAnimation: UITableView.RowAnimation, completion: ((Bool)->Void)?) {
        tableView.performBatchUpdates({
            tableView.beginUpdates()
            tableView.deleteRows(at: deletionIndexPaths, with: deletionAnimation)
            tableView.insertRows(at: insertionIndexPaths, with: insertionAnimation)
            tableView.endUpdates()
        }, completion: completion)
    }
}
