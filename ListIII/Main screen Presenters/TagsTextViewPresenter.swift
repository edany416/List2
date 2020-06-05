//
//  TagsTextViewPresenter.swift
//  ListIII
//
//  Created by Edan on 6/3/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation

protocol TagsTextViewPresenterDelegate: class {
    func didTapTextView()
}

class TagsTextViewPresenter {
    private var tags: [Tag]!
    var selectedTags: [String] {
        return tags.map({$0.name!})
    }
    
    weak var delegate: TagsTextViewPresenterDelegate?
    
    init(_ tags: [Tag]) {
        self.tags = tags
    }
    
    func setTags(fromNewTags tags: [Tag]) {
        self.tags = tags
    }
}

extension TagsTextViewPresenter: TagsTextViewDelegate {
    func didTapTextView() {
        delegate?.didTapTextView()
    }
}
