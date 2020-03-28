//
//  TaskDetailViewController.swift
//  ListIII
//
//  Created by Edan on 3/28/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    var taskid: String?
    
    private var tagPickerView: TagPickerView!
    private var popupAnimator: ViewPopUpAnimator!
    private var popupViewHeight: CGFloat!
    private var tagPickerManager: TagPickerManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if taskid != nil {
            //At this point populate everything as we are in an edit state
        }
        
    }
    
    private func setupTagPickerView() {
        tagPickerView = TagPickerView()
        let width = view.bounds.width * 0.80
        let tagPickerHeight = width
        tagPickerView!.widthAnchor.constraint(equalToConstant: width).isActive = true
        tagPickerView!.heightAnchor.constraint(equalToConstant: tagPickerHeight).isActive = true
        tagPickerView!.tableViewDelegate = tagPickerManager
        tagPickerView?.tableViewDataSource = tagPickerManager
        tagPickerView.topLeftButton.setTitle("Cancel", for: .normal)
        tagPickerView.topRightButton.setTitle("Add New", for: .normal)
        tagPickerView!.delegate = self
    }
}

extension TaskDetailViewController: TagPickerManagerDelegate {
    func didSelectItem(_ tag: String) {
        print("Do this")
    }
    
    func didDeselectItem(_ tag: String) {
        print("Do this")
    }
}

extension TaskDetailViewController: TagPickerViewDelegate {
    func didTapMainButton() {
        print("Do this")
    }
    
    func didTapTopLeftButton() {
        print("Do this")
    }
    
    func didTapTopRightButton() {
        print("Do this")
    }
    
    func didSearch(for query: String) {
        print("Do this")
    }
    
    
}
