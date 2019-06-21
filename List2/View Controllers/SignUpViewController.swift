//
//  SignUpViewController.swift
//  List2
//
//  Created by edan yachdav on 5/26/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Make continue button not tappable is either email or password fields are empty
    //Then this action will be called iff fields are non empty and we can force unwrap the optionals
    @IBAction func continueTapped(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        UserServices.sharedInstance.signUp(withEmail: email, password: password) { (success) in
            if success {
                //Perform appropriate segue
            } else {
                //Error handling stuff
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
