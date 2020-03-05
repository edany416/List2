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

class TagFilterView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var tagsTableView: UITableView!
    
    var delegate: TagFilterViewDelegate?
    
    private var nonSelectedData: [String]!
    private var selectedData: [String]!
    
    
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
        nonSelectedData = model.nonSelectedData
        selectedData = model.selectedData
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

extension TagFilterView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && !selectedData!.isEmpty {
            return selectedData.count
        }
        return nonSelectedData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedData!.isEmpty ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 && !selectedData.isEmpty {
            return "Selected Tags"
        }
        return "Available Tags"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tagsTableView.dequeueReusableCell(withIdentifier: "TagFilterCell", for: indexPath) as! TagFilterCell
        
        let tagName: String!
        if indexPath.section == 0 && !selectedData.isEmpty {
            tagName = selectedData[indexPath.row]
        } else {
            tagName = nonSelectedData[indexPath.row]
        }
        cell.configureCell(from: TagFilterCellModel(tagName: tagName))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItemName: String!
        if indexPath.section == 0 && !selectedData.isEmpty {
            selectedItemName = selectedData.remove(at: indexPath.row)
            nonSelectedData.append(selectedItemName)
            delegate?.didDeselectItem(with: selectedItemName)
        } else {
            selectedItemName = nonSelectedData.remove(at: indexPath.row)
            selectedData.append(selectedItemName)
            delegate?.didSelectItem(with: selectedItemName)
        }
        tagsTableView.reloadData()
    }
    
    
}
