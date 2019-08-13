//
//  AddPopUpView.swift
//  List2
//
//  Created by edan yachdav on 8/12/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

protocol AddPopUpDelegate {
    func didTapNewTask(_ popUpView: AddPopUpView)
    func didTapNewTag(_ popUpView: AddPopUpView)
}

class AddPopUpView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var newTaskButton: UIButton!
    @IBOutlet private var newTagButton: UIButton!
    
    var delegate: AddPopUpDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    @IBAction func onTapNewTask(_ sender: Any) {
        delegate?.didTapNewTask(self)
    }
    
    @IBAction func onTapNewTag(_ sender: Any) {
        delegate?.didTapNewTag(self)
    }
    
    private func setup() {
        Bundle.main.loadNibNamed("AddPopUpView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
