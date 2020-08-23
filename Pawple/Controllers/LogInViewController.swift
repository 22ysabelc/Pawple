//
//  LogInViewController.swift
//  Pawple
//
//  Created by 22ysabelc on 4/26/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var window: UIWindow?
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            if !email.isValidEmail() {
                self.alert(title: "Email is invalid", message: "")
                return
            }
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.alert(title: "Error with email or password", message: e.localizedDescription)
                } else {
                    self.navigationController?.dismiss(animated: true)
                }
            }
        }
    }
    
    
}
