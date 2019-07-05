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
    @IBOutlet weak var signUpButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.isHidden = true
    }
    
    @IBAction func continueTapped(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        UserServices.sharedInstance.signUp(withEmail: email, password: password) { (success) in
            if success {
                self.performSegue(withIdentifier: "SignUpSuccessful", sender: nil)
            } else {
                let errorAlert = ErrorAlertController(errorMessage: "Error logging in")
                self.present(errorAlert.errorAlertControler, animated: true, completion: {
                    self.resetSceenState()
                })
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
    
    
    @IBAction func emailTextChanged(_ sender: UITextField) {
        setSignupButtonState()
    }
    
    @IBAction func passwordTextChanged(_ sender: UITextField) {
        setSignupButtonState()
    }
    
    private func setSignupButtonState() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            if !email.isEmpty && (password.count >= 6) {
                signUpButton.isHidden = false
            } else {
                signUpButton.isHidden = true
            }
        }
    }
    
    private func resetSceenState() {
        emailTextField.text = ""
        passwordTextField.text = ""
        signUpButton.isHidden = true
    }
}
