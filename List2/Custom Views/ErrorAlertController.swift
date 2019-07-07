//
//  ErrorAlertController.swift
//  List2
//
//  Created by edan yachdav on 7/4/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import Foundation
import UIKit

class ErrorAlertController {
    private let alertController: UIAlertController!
    
    var errorAlertControler: UIAlertController {
        get {
            return alertController
        }
    }
    
    init(errorMessage: String) {
        alertController = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
    }
}
