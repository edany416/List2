//
//  UserServices.swift
//  List2
//
//  Created by edan yachdav on 6/17/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import Foundation
import FirebaseAuth

class UserServices {
    
    static let sharedInstance = UserServices()
    
    var userID: String {
        get {
            return Auth.auth().currentUser!.uid
        }
    }
    
    func signUp(withEmail email: String, password: String, signUpSuccessful: @escaping (Bool) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                signUpSuccessful(false)
                print("Sign up error has occured \(error!.localizedDescription)")
            } else {
                print("User was successfully signed up")
                let userLoginInfo = ["email": email, "password": password]
                DBManager.instance.createUser(uid: self.userID, loginInfo: userLoginInfo)
                signUpSuccessful(true)
            }
        }
    }
}




