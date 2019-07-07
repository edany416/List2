//
//  LoginViewController.swift
//  List2
//
//  Created by edan yachdav on 5/26/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserServices.sharedInstance.userIsLoggedIn {
            emailTextField.text = UserServices.sharedInstance.emailAddress
        }
        loginButton.setInteractiveState(to: .disabled)
    }
    
    @IBAction func emailTextChanged(_ sender: UITextField) {
        setLoginButtonState()
    }
    
    @IBAction func passwordTextChanged(_ sender: Any) {
        setLoginButtonState()
    }
    
    private func setLoginButtonState() {
        if let emailText = emailTextField.text, let passwordText = passwordTextField.text {
            if emailText.count > 0 && passwordText.count > 0 {
                loginButton.setInteractiveState(to: .enabled)
            } else {
                loginButton.setInteractiveState(to: .disabled)
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
