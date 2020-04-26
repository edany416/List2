//
//  TaskDetailViewControllerViewModel.swift
//  ListIII
//
//  Created by Edan on 4/24/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation

protocol TaskDetailViewControllerViewModelDelegate: class {
    func shouldConfigureForEditting(_ editting: Bool)
}

class TaskDetailViewControllerViewModel {
    private var task: Task?
    
    weak var delegate: TaskDetailViewControllerViewModelDelegate?
    
    init(with task: Task?) {
        delegate?.shouldConfigureForEditting((task == nil))
    }
}
