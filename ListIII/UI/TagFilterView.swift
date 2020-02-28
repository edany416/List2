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
}

class TagFilterView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet private weak var applyButton: UIButton!
    @IBOutlet private weak var tagsCollectionView: UICollectionView!
    
    var delegate: TagFilterViewDelegate?
    
    private var nonSelectedData: [String]!
    private var selectedData: [String]! {
        didSet {
            applyButton.isEnabled = self.selectedData.count != 0
            let result = TaskFilter.numTasksForTags(named: selectedData)
            applyButton.setTitle("Show Tasks (\(result))", for: .normal)
        }
    }
    
    
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
        tagsCollectionView.reloadData()
        
        applyButton.isEnabled = false
        applyButton.layer.cornerRadius = 5.0
    }
    
    func configure(from model: TagFilterViewModel) {
        nonSelectedData = model.nonSelectedData
        selectedData = model.selectedData
        tagsCollectionView.reloadData()
    }
    
    private func configureCollectionView() {
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        let nib = UINib(nibName: "TagCollectionViewCell", bundle:nil)
        tagsCollectionView.register(nib, forCellWithReuseIdentifier: "TagCell")
        tagsCollectionView.backgroundColor = .clear
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }
    
    @IBAction func didTapCancel(_ sender: UIButton) {
        delegate?.didTapCancelButton()
    }
    
}

extension TagFilterView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 && !selectedData.isEmpty {
            return selectedData.count
        } else {
            return nonSelectedData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tagsCollectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCollectionViewCell
        var dataToDisplay: String!
        if indexPath.section == 0 && !selectedData.isEmpty {
            dataToDisplay = selectedData[indexPath.row]
            cell.setState(to: .selected)
        } else {
            dataToDisplay = nonSelectedData[indexPath.row]
            cell.setState(to: .notSelected)
        }
        cell.configureCell(from: TagCellModel(tagName: dataToDisplay))
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return selectedData.isEmpty ? 1 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tapped: String!
        if indexPath.section == 0 && !selectedData.isEmpty {
            tapped = selectedData.remove(at: indexPath.row)
            nonSelectedData.append(tapped)
        } else {
            tapped = nonSelectedData.remove(at: indexPath.row)
            selectedData.append(tapped)
        }
        tagsCollectionView.reloadData()
    }
}
