//
//  TestViewController.swift
//  ListIII
//
//  Created by Edan on 3/20/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, FilterTagPickerPresenterDelegate {
    func didPerformTagSearch() {
        tagFilter.clearSearchBar()
        tagFilter.reloadData()
    }
    
    
    @IBOutlet weak var tagFilter: TagPickerView!
    var presenter: FilterTagPickerPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tags = PersistanceManager.instance.fetchTags()
        presenter = FilterTagPickerPresenter(fromSelectedTags: [], selectionTags: tags, allAvailableTags: tags)
        tagFilter.delegate = presenter
        tagFilter.tableViewDelegate = presenter.tableViewSelectionManager
        tagFilter.tableViewDataSource = presenter.tableViewSelectionManager
        tagFilter.reloadData()
        
        presenter.delegate = self
    }
    
    
    @IBAction func button(_ sender: Any) {
        
        let tags = PersistanceManager.instance.fetchTags()
        let selected = Array(tags[0..<4])
        let selection = Util.associatedTags(for: selected)
        //presenter.set(selectedTags: selected, selectionTags: selection, allAvailableTags: <#[Tag]#>)
        tagFilter.reloadData()
        
    }
    
    
    
    func didApplySelectedTags(_ tags: [Tag]) {
        print("did apply")
        
    }
    
    func didSelectTag(_ tag: Tag) {
        print("did select")
        
    }
    
    func didDeselectTag(_ tag: Tag) {
        print("did deselect")
        
    }
    
    func selectedTagsDidChange() {
        print("selected tags did change")
    }
    
    func didCancelSelection() {
        tagFilter.reloadData()
    }
    
    func didClearAllSelectedTags() {
        tagFilter.reloadData()
    }
}
