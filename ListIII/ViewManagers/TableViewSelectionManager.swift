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
    func didSelect(item: Any)
    func willDeselectItem(item: Any)
    func didDeselectItem(item: Any)
    func cellDetails(forItem item: Any) -> TableViewCellDetails
}

class TableViewSelectionManager<Element: Comparable>: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private(set) var selectionItems: [Element]
    private(set) var selectedItems: [Element]
    
    weak var delegate: TableViewSelectionManagerDelegate?
    
    override init() {
        selectionItems = [Element]()
        selectedItems = [Element]()
    }
    
    func set(selectionItems: [Element], sortOrder: ((Element, Element) -> Bool)?) {
        self.selectionItems = selectionItems
        
        if sortOrder != nil {
            self.selectionItems = self.selectionItems.sorted(by: sortOrder!)
        }
    }
    
    func set(selectedItems: [Element]) {
        self.selectedItems = selectedItems
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numSections = Int()
        switch section {
        case 0:
            numSections = selectedItems.count
        case 1:
            numSections = selectionItems.count
        default:
            return 0
        }
        return numSections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if delegate != nil {
            var cellDetails: TableViewCellDetails!
            if indexPath.section == 0 {
                cellDetails = delegate!.cellDetails(forItem: selectedItems[indexPath.row])
            } else if indexPath.section == 1 {
                cellDetails = delegate!.cellDetails(forItem: selectionItems[indexPath.row])
            }
            cell = tableView.dequeueReusableCell(withIdentifier: cellDetails.identifier, for: indexPath)
            cellDetails.viewModel.configure(cell, fromPropertyModel: cellDetails.propertyModel)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexOfInsertion: IndexPath
        let item: Element
        
        if indexPath.section == 0 {
            item = selectedItems.remove(at: indexPath.row)
            let index = indexForDeselectedItem(item)
            selectionItems.insert(item, at: index)
            indexOfInsertion = IndexPath(row: index, section: 1)
            
            performSelectionUpdate(tableView, fromIndexPath: indexPath, toIndexPath: indexOfInsertion) { (finished) in
                self.delegate?.didDeselectItem(item: item)
            }
            
        } else if indexPath.section == 1 {
            item = selectionItems.remove(at: indexPath.row)
            selectedItems.append(item)
            indexOfInsertion = IndexPath(row: selectedItems.count-1, section: 0)
            performSelectionUpdate(tableView, fromIndexPath: indexPath, toIndexPath: indexOfInsertion, completion: { finished in
                self.delegate?.didSelect(item: item)
            })
        }
        
//        if indexPath.row < selectedItems.count { //Deselection case
//            item = selectedItems.remove(at: indexPath.row)
//            let (rowIndex, itemsIndex) = indexForDeselectedItem(item)
//            selectionItems.insert(item, at: itemsIndex)
//            indexOfInsertion = IndexPath(row: rowIndex, section: 0)
//            performSelectionUpdate(tableView, fromIndexPath: indexPath, toIndexPath: indexOfInsertion, completion: { finished in
//                self.delegate?.didDeselectItem(item: item)
//            })
//
//        } else { //Selection Case
//            item = selectionItems.remove(at: indexPath.row - selectedItems.count)
//            selectedItems.append(item)
//            indexOfInsertion = IndexPath(row: selectedItems.count - 1, section: 0)
//            performSelectionUpdate(tableView, fromIndexPath: indexPath, toIndexPath: indexOfInsertion, completion: { finished in
//                self.delegate?.didSelect(item: item)
//            })
//        }
    }
    
    private func performSelectionUpdate(_ tableView: UITableView, fromIndexPath: IndexPath, toIndexPath: IndexPath, completion: @escaping (Bool) -> Void) {
        tableView.performBatchUpdates({
            tableView.beginUpdates()
            tableView.deleteRows(at: [fromIndexPath], with: .right)
            tableView.insertRows(at: [toIndexPath], with: .right)
            tableView.endUpdates()
        }, completion: completion)
    }
    
    private func indexForDeselectedItem(_ item: Element) -> Int { //(RowIndex, ItemsIndex)
        let index = selectionItems.firstIndex(where: {item < $0})
        if index != nil {
            return (index!)
        } else if selectionItems.isEmpty {
            return 0
        } else {
            return selectionItems.count
        }
    }

}
