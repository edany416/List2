//
//  AlertFactory.swift
//  ListIII
//
//  Created by Edan on 5/4/20.
//  Copyright © 2020 Edan. All rights reserved.
//

import Foundation
import UIKit

enum ErrorType {
    case emptyTaskName
    case emptyTags
    case emptyForm
}
private struct AlertDetails {
    let title: String
    let message: String
}
struct AlertFactory {
    private static let alertDetails: [ErrorType:AlertDetails] = [
        ErrorType.emptyTaskName : AlertDetails(title: "Missing task name", message: "Task must have a name"),
        ErrorType.emptyTags : AlertDetails(title: "Missing tags", message: "Task must include tags"),
        ErrorType.emptyForm : AlertDetails(title: "Missing info", message: "Task name and tags field cannot be empty")
    ]
    
    static func createAlert(ofType alertType: ErrorType) -> UIAlertController {
        let details = AlertFactory.alertDetails[alertType]!
        let alertController = UIAlertController(title: details.title, message: details.message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        return alertController
    }
}
