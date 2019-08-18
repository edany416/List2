//
//  TagSortView.swift
//  List2
//
//  Created by edan yachdav on 8/18/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

enum SortingType {
    case alpha
    case associatedTasks
}

protocol SortViewDelegate {
    func didTapSort(by sortType: SortingType)
}

class TagSortView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet private weak var sortAlphaButton: UIButton!
    @IBOutlet private weak var sortAssociatedTasksButton: UIButton!
    var delegate: SortViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
   
    private func setup() {
        Bundle.main.loadNibNamed("TagSortView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        sortAlphaButton.setTitleColor(.black, for: .normal)
        sortAssociatedTasksButton.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func onTappedAlphabetically(_ sender: Any) {
        sortAlphaButton.setTitleColor(.black, for: .normal)
        sortAssociatedTasksButton.setTitleColor(.white, for: .normal)
        delegate?.didTapSort(by: .alpha)
    }
    
    @IBAction func onTappedAssociatedTasks(_ sender: Any) {
        sortAlphaButton.setTitleColor(.white, for: .normal)
        sortAssociatedTasksButton.setTitleColor(.black, for: .normal)
        delegate?.didTapSort(by: .associatedTasks)
    }
}
