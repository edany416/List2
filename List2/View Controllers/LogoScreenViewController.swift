//
//  LogoScreenViewController.swift
//  List2
//
//  Created by edan yachdav on 5/26/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class LogoScreenViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: RoundedButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.backgroundColor = UIColor.white
        signUpButton.outlineColor = UIColor.black
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
