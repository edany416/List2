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
        loginButton.backgroundColor = Constants.DISABLED_BUTTON_COLOR
        loginButton.outlineColor = Constants.DISABLED_BUTTON_COLOR
        loginButton.isEnabled = false
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
                loginButton.backgroundColor = .black
                loginButton.outlineColor = .black
                loginButton.isEnabled = true
            } else {
                loginButton.backgroundColor = Constants.DISABLED_BUTTON_COLOR
                loginButton.outlineColor = Constants.DISABLED_BUTTON_COLOR
                loginButton.isEnabled = false
            }
        }
    }
    
    @IBAction func loginTapped(_ sender: RoundedButton) {
        let email = emailTextField.text
        let password = passwordTextField.text
        UserServices.sharedInstance.logIn(withEmail: email!, password: password!) { (success) in
            if success {
                let main = UIStoryboard(name: "Main", bundle: nil)
                let mainNavVC = main.instantiateViewController(withIdentifier: "MainNavigationController")
                self.present(mainNavVC, animated: true, completion: nil)
            } else {
                let invalidLoginCredentials = ErrorAlertController(errorMessage: "Incorrect email or password")
                self.present(invalidLoginCredentials.errorAlertControler, animated: true, completion: nil)
            }
        }
    }
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
