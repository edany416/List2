//
//  TagFilterView.swift
//  ListIII
//
//  Created by Edan on 2/26/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit

struct TagFilterViewModel {
    let nonSelectedData: [String]
    let selectedData: [String]
}

protocol TagFilterViewDelegate {
    func didTapCancelButton()
    func didSelectItem(with name: String)
    func didDeselectItem(with name: String)
    func didTapApply()
}

class TagSelectorView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var tagsTableView: UITableView!
    
    var delegate: TagFilterViewDelegate?
    
    private var nonSelectedItems: [String]!
    private var selectedItems: [String]!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        Bundle.main.loadNibNamed("TagFilterView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        configureCollectionView()
        applyButton.layer.cornerRadius = 5.0
    }
    
    func configure(from model: TagFilterViewModel) {
        nonSelectedItems = model.nonSelectedData.sorted(by: <)
        selectedItems = model.selectedData
        tagsTableView.reloadData()
    }
    
    private func configureCollectionView() {
        tagsTableView.delegate = self
        tagsTableView.dataSource = self
        let nib = UINib(nibName: "TagFilterCell", bundle:nil)
        tagsTableView.register(nib, forCellReuseIdentifier: "TagFilterCell")
        tagsTableView.backgroundColor = .clear
        self.layer.cornerRadius = 15.0
        self.layer.masksToBounds = true
        
    }
    
    @IBAction func didTapApply(_ sender: UIButton) {
        delegate?.didTapApply()
    }
    
    @IBAction func didTapCancel(_ sender: UIButton) {
        delegate?.didTapCancelButton()
    }
}

extension TagSelectorView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedItems.count + nonSelectedItems.count
    }
    
    private func getDataFrom(indexPath: IndexPath) -> (String,Bool) {
        if indexPath.row < selectedItems.count {
            return (selectedItems[indexPath.row], true)
        }
        return (nonSelectedItems[indexPath.row - selectedItems.count], false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tagsTableView.dequeueReusableCell(withIdentifier: "TagFilterCell", for: indexPath) as! TagFilterCell
        
        let (tagName, selected) = getDataFrom(indexPath: indexPath)
        cell.configureCell(from: TagFilterCellModel(tagName: tagName))
        if selected {
            cell.setSelectionState(to: .selected)
        } else {
            cell.setSelectionState(to: .notSelected)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= selectedItems.count {
            let index = indexPath.row - selectedItems.count
            let selectedItem = nonSelectedItems.remove(at: index)
            selectedItems.append(selectedItem)
            tagsTableView.beginUpdates()
            tagsTableView.deleteRows(at: [indexPath], with: .right)
            tagsTableView.insertRows(at: [IndexPath(row: selectedItems.count - 1, section: 0)], with: .right)
            tagsTableView.endUpdates()
            delegate?.didSelectItem(with: selectedItem)
        } else {
            let deselectedItem = selectedItems.remove(at: indexPath.row)
            let indexOfInsertion: IndexPath!
            if let index = nonSelectedItems.firstIndex(where: {deselectedItem < $0}) {
                indexOfInsertion = IndexPath(row: selectedItems.count + index, section: 0)
                nonSelectedItems.insert(deselectedItem, at: index)
            } else if nonSelectedItems.count == 0 {
                indexOfInsertion = IndexPath(row: selectedItems.count, section: 0)
                nonSelectedItems.append(deselectedItem)
            } else {
                indexOfInsertion = IndexPath(row: tagsTableView.numberOfRows(inSection: 0) - 1, section: 0)
                nonSelectedItems.append(deselectedItem)
            }
            tagsTableView.beginUpdates()
            tagsTableView.deleteRows(at: [indexPath], with: .right)
            tagsTableView.insertRows(at: [indexOfInsertion], with: .right)
            tagsTableView.endUpdates()
            delegate?.didDeselectItem(with: deselectedItem)
        }
    }
}
