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
    
    func signUp(withEmail email: String, password: String, signUpReturned: @escaping (Bool) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print("Sign up error has occured \(error!.localizedDescription)")
                return
            } else {
                print("User was successfully signed up")
                signUpReturned(true)
            }
        }
    }
}




