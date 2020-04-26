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
    func updateSelectionItemsFor<T: Hashable & Comparable>(item: T, selected: Bool) -> [T]?
    func cellDetails<T: Hashable & Comparable>(forItem item: T) -> TableViewCellDetails
}

protocol Selectable {
    func selected(_ isSelected: Bool)
}

class TableViewSelectionManager<T: Hashable & Comparable>: NSObject, UITableViewDataSource, UITableViewDelegate {
    private(set) var selectionItems: [T]
    private(set) var selectedItems: [T]
    private var insertionIndexPaths: [IndexPath]
    private var deletionIndexPaths: [IndexPath]
    
    weak var delegate: TableViewSelectionManagerDelegate?
    
    override init() {
        selectionItems = [T]()
        selectedItems = [T]()
        insertionIndexPaths = [IndexPath]()
        deletionIndexPaths = [IndexPath]()
        
    }
    
    func set(selectionItems: [T], sortOrder: ((T, T) -> Bool)?) {
        self.selectionItems = selectionItems.sorted(by: < )
        
//        if sortOrder != nil {
//            self.selectionItems = self.selectionItems.sorted(by: sortOrder!)
//        }
    }
    
    func set(selectedItems: [T]) {
        self.selectedItems = selectedItems.sorted(by: < )
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
        insertionIndexPaths.removeAll()
        deletionIndexPaths.removeAll()
        var item: T!
        if indexPath.section == 1 { //Selection case
            item = selectionItems.remove(at: indexPath.row)
            selectedItems.insert(item, at: selectedItems.count)
            let indexOfInsertion = IndexPath(row: selectedItems.count-1, section: 0)
            let indexOfDeletion = IndexPath(row: indexPath.row, section: 1)
            performRowUpdates(tableView, insertionUpdates: [indexOfInsertion], deletionUpdates: [indexOfDeletion], deletionAnimation: .fade, insertionAnimation: .right) { [weak self] (finished) in
                if let updatedList = self?.delegate?.updateSelectionItemsFor(item: item, selected: true) {
                    self?.updateList(from: Set(updatedList), tableView)
                    self?.performRowUpdates(tableView, insertionUpdates: self!.insertionIndexPaths, deletionUpdates: self!.deletionIndexPaths, deletionAnimation: .fade, insertionAnimation: .fade, completion: nil)
                }
            }
        } else {
            item = selectedItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
            if let updatedList = self.delegate?.updateSelectionItemsFor(item: item, selected: false) {
                self.updateList(from: Set(updatedList), tableView)
                performRowUpdates(tableView, insertionUpdates: insertionIndexPaths, deletionUpdates: deletionIndexPaths, deletionAnimation: .fade, insertionAnimation: .fade, completion: nil)
            } else {
                let indexOfInsertion = insertionIndexForDeselectedItem(item)
                selectionItems.insert(item, at: indexOfInsertion)
                performRowUpdates(tableView, insertionUpdates: [IndexPath(row: indexOfInsertion, section: 1)], deletionUpdates: [], deletionAnimation: .fade, insertionAnimation: .fade, completion: nil)
            }
            
        }
    }
        
    
    private func updateList(from list: Set<T>, _ tableView: UITableView) {
        var updatedSet = list
        var newSelectionItems = [T]()
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
        selectionItems = selectionItems.sorted(by: < )
        
        for (index, item) in selectionItems.enumerated() {
            if updatedSet.contains(item) {
                let rowToInsert = IndexPath(row: index, section: 1)
                insertionIndexPaths.append(rowToInsert)
            }
        }
    }
    
    private func performRowUpdates(_ tableView: UITableView, insertionUpdates insertionIndexPaths: [IndexPath], deletionUpdates deletionIndexPaths: [IndexPath], deletionAnimation: UITableView.RowAnimation, insertionAnimation: UITableView.RowAnimation, completion: ((Bool)->Void)?) {
        tableView.performBatchUpdates({
            tableView.beginUpdates()
            tableView.deleteRows(at: deletionIndexPaths, with: deletionAnimation)
            tableView.insertRows(at: insertionIndexPaths, with: insertionAnimation)
            tableView.endUpdates()
        }, completion: completion)
    }
    
    private func insertionIndexForDeselectedItem(_ item: T) -> Int {
        let index = selectionItems.firstIndex(where: {item < $0})
        if index == nil {
            return selectionItems.count
        }
        return index!
    }
}
