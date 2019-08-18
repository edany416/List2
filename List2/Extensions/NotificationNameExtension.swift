//
//  NotificationNameExtension.swift
//  List2
//
//  Created by edan yachdav on 7/31/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let didCompleteTodo = Notification.Name("didCompleteTodo")
    static let didAddDuplicateTask = Notification.Name("didAddDuplicateTask")
    static let didAddDuplicateTag = Notification.Name("didAddDupicateTag")
}
