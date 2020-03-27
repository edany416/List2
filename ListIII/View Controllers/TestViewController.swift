//
//  TestViewController.swift
//  ListIII
//
//  Created by Edan on 3/20/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, SearchBarDelegate {
    @IBOutlet weak var searchBar: SearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    func textDidChangeTo(_ query: String) {
        print(query)
    }
}
