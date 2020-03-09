//
//  TagPickerView.swift
//  ListIII
//
//  Created by Edan on 3/8/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit

protocol TagPickerViewDelegate {
    func didTapMainButton()
    func didTapTopLeftButton()
    func didTapTopRightButton()
}

class TagPickerView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var topRightButton: UIButton!
    @IBOutlet weak var topLeftButton: UIButton!
    @IBOutlet weak var pickerTableView: UITableView!
    
    var delegate: TagPickerViewDelegate?
    
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
        
        let nib = UINib(nibName: "TagFilterCell", bundle:nil)
        pickerTableView.register(nib, forCellReuseIdentifier: "TagFilterCell")
    }
    
    @IBAction func didTapMainButton(_ sender: UIButton) {
        delegate?.didTapMainButton()
    }
    
    @IBAction func didTapTopLeftButton(_ sender: UIButton) {
        delegate?.didTapTopLeftButton()
    }
    
    @IBAction func didTapTopRightButton(_ sender: UIButton) {
        delegate?.didTapTopRightButton()
    }
}
