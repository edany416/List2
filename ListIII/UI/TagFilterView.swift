//
//  TagFilterView.swift
//  ListIII
//
//  Created by Edan on 2/26/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit

class TagFilterView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet private weak var applyButton: UIButton!
    @IBOutlet private weak var tagsCollectionView: UICollectionView!
    
    private var tags: [Tag]!
    private var selectedTags: [Tag]! {
        didSet {
            applyButton.setTitle("Apply Tag (\(self.selectedTags.count))", for: .normal)
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
        loadData()
        tagsCollectionView.reloadData()
    }
    
    private func configureCollectionView() {
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        let nib = UINib(nibName: "TagCollectionViewCell", bundle:nil)
        tagsCollectionView.register(nib, forCellWithReuseIdentifier: "TagCell")
        tagsCollectionView.backgroundColor = .clear
    }
    
    private func loadData() {
        //tags = PersistanceManager.instance.fetchTags()
        tags = TestUtilities.loadTagsFromJSON()
        selectedTags = [Tag]()
    }

}

extension TagFilterView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 && !selectedTags.isEmpty {
            return selectedTags.count
        } else {
            return tags.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tagsCollectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCollectionViewCell
        let tag = getTag(from: indexPath)
        cell.configureCell(from: TagCellModel(tagName: tag.name!))
        tag.selected ? cell.setState(to: .selected) : cell.setState(to: .notSelected)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return selectedTags.isEmpty ? 1 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tappedTag: Tag!
        if indexPath.section == 0 && !selectedTags.isEmpty {
            tappedTag = selectedTags.remove(at: indexPath.row)
            tags.append(tappedTag)
        } else {
            tappedTag = tags.remove(at: indexPath.row)
            selectedTags.append(tappedTag)
        }
        tappedTag.selected = !tappedTag.selected
        tagsCollectionView.reloadData()
    }
    
    private func getTag(from indexPath: IndexPath) -> Tag {
        if indexPath.section == 0 && !selectedTags.isEmpty {
            return selectedTags[indexPath.row]
        } else {
            return tags[indexPath.row]
        }
    }
}
