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
    
    private var selectedTags: [Tag]?
    private var tags: [Tag]!
    
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
    }
    
    private func configureCollectionView() {
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        let nib = UINib(nibName: "TagCollectionViewCell", bundle:nil)
        tagsCollectionView.register(nib, forCellWithReuseIdentifier: "TagCell")
    }
    
    private func loadData() {
        tags = PersistanceManager.instance.fetchTags()
    }

}

extension TagFilterView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //let numSelectedTags = selectedTags?.count ?? 0
        //let numTags = tags.count
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tagsCollectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCollectionViewCell
        cell.name.text = "Test"
        return cell
    }
    
    
}
