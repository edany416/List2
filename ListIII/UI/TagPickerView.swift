//
//  TagPickerView.swift
//  ListIII
//
//  Created by Edan on 3/8/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit

protocol TagPickerViewDelegate: class {
    func didTapMainButton()
    func didTapTopLeftButton()
    func didTapTopRightButton()
    func didSearch(for query: String)
}

class TagPickerView: UIView, SearchBarDelegate {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var topRightButton: UIButton!
    @IBOutlet weak var topLeftButton: UIButton!
    @IBOutlet private weak var pickerTableView: UITableView!
    @IBOutlet private weak var searchBar: SearchBar!
    
    weak var delegate: TagPickerViewDelegate?
    var tableViewDataSource: UITableViewDataSource? {
        didSet {
            pickerTableView.dataSource = self.tableViewDataSource
        }
    }
    var tableViewDelegate: UITableViewDelegate? {
        didSet {
            pickerTableView.delegate = self.tableViewDelegate
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
        
        let nib = UINib(nibName: "TagFilterCell", bundle:nil)
        pickerTableView.register(nib, forCellReuseIdentifier: "TagFilterCell")
        
        self.contentView.layer.cornerRadius = 15.0
        self.contentView.layer.masksToBounds = true
        
        self.mainButton.layer.cornerRadius = 7.0
        
        searchBar.delegate = self
    }
    
    func reloadData() {
        pickerTableView.reloadData()
    }
    
    func clearSearchBar() {
        searchBar.clear()
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
    
    func textDidChangeTo(_ query: String) {
        delegate?.didSearch(for: query)
    }
}
