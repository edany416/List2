//
//  DBManager.swift
//  List2
//
//  Created by edan yachdav on 7/4/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import Foundation
import Firebase

let DB_ROOT = Database.database().reference()

class DBManager {
    
    static let instance = DBManager()
    
    private var _REF_ROOT = DB_ROOT
    private var _REF_USERS = DB_ROOT.child("users")
    
    func createUser(uid: String, loginInfo: Dictionary<String, Any>) {
        _REF_USERS.child(uid).updateChildValues(loginInfo)
    }
    
}
