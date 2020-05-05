//
//  TagsTextFieldPresenter.swift
//  ListIII
//
//  Created by Edan on 5/4/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation

protocol TagsTextViewPresenterDelegate: class {
    func shouldUpdateTags(_ tags: [String])
}

class TagsTextViewPresenter {
    
    private var tags: [Tag]!
    weak var delegate: TagsTextViewPresenterDelegate?
    
    init() {
        tags = [Tag]()
        NotificationCenter.default.addObserver(self, selector: #selector(tagSelectionListener(_:)), name: .SelectedTagsDidChangeNotification, object: nil)
    }
    
    @objc private func tagSelectionListener(_ notification: NSNotification) {
        if let tags = notification.userInfo?["Tags"] as? [Tag] {
            delegate?.shouldUpdateTags(tags.map({$0.name!}))
        }
    }
}
