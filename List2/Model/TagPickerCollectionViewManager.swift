//
//  RunningTagsCollectionViewManager.swift
//  List2
//
//  Created by edan yachdav on 9/28/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import Foundation
import UIKit

protocol TagPickerCollectionViewDelegate {
    func didTapCellForTag(tag: Tag, selected: Bool)
}

class TagPickerCollectionViewManager: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    private weak var tagsCollectionView: UICollectionView!
    private var tapTracker: TapTracker!
    private var filter: TagFilter!
    private var tags = [Tag]() {
        didSet{
            tagsCollectionView.reloadData()
        }
    }
    
    var delegate: TagPickerCollectionViewDelegate?
    
    init(collectionView: UICollectionView, data: [Tag]) {
        super.init()
        tagsCollectionView = collectionView
        tagsCollectionView.register(UINib.init(nibName: "TagFilterCell", bundle: nil), forCellWithReuseIdentifier: "TagFilterCell")
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        tags = data
        tapTracker = TapTracker(tags: tags)
        filter = TagFilter(Set(tags))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tagsCollectionView.dequeueReusableCell(withReuseIdentifier: "TagFilterCell", for: indexPath) as! TagCell
        cell.title.text = tags[indexPath.row].name
        let isCellTapped = tapTracker.tapStatus(for: tags[indexPath.row])
        if isCellTapped {
            cell.tapped = true
        } else {
            cell.tapped = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = collectionView.cellForItem(at: indexPath) as? TagCell{
            let tag = tags[indexPath.row]
            tapTracker.setTappedStatus(for: tag)
            tags = filter.associatedTags(for: tag)
            delegate?.didTapCellForTag(tag: tag, selected: tapTracker.tapStatus(for: tag))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = tags[indexPath.row]
        let tagName = tag.name! as NSString
        let sizeOfTagName = tagName.size(withAttributes: [.font: UIFont.systemFont(ofSize: 20)])
        let size = CGSize(width: sizeOfTagName.width, height: sizeOfTagName.height)
        return size
    }
    //Need function for updating the tags when that happens
}
