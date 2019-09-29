//
//  SelectedTagsCollectionViewManager.swift
//  List2
//
//  Created by edan yachdav on 9/28/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import Foundation
import UIKit

class SelectedTagsCollectionViewManager: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private weak var selectedTagCollectionView: UICollectionView!
    private var selectedTags = [Tag]() {
        didSet {
            self.selectedTagCollectionView.reloadData()
        }
    }
    
    init(collectionView: UICollectionView) {
        super.init()
        self.selectedTagCollectionView = collectionView
        selectedTagCollectionView.delegate = self
        selectedTagCollectionView.dataSource = self
        selectedTagCollectionView.register(UINib.init(nibName: "TagFilterCell", bundle: nil), forCellWithReuseIdentifier: "TagFilterCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = selectedTagCollectionView.dequeueReusableCell(withReuseIdentifier: "TagFilterCell", for: indexPath) as! TagCell
        cell.title.text = selectedTags[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = selectedTags[indexPath.row]
        let tagName = tag.name! as NSString
        let sizeOfTagName = tagName.size(withAttributes: [.font: UIFont.systemFont(ofSize: 20)])
        let size = CGSize(width: sizeOfTagName.width, height: collectionView.frame.height)
        return size
    }
    
    func updateWithTag(tag: Tag, removing: Bool) {
        if removing {
            let index = selectedTags.firstIndex(of: tag)
            selectedTags.remove(at: index!)
        } else {
            selectedTags.append(tag)
        }
        selectedTagCollectionView.reloadData()
    }
}
