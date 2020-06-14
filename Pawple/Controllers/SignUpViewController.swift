//
//  SignUpViewController.swift
//  Pawple
//
//  Created by 22ysabelc on 4/26/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signupPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            if !email.isValidEmail() {
                self.alert(title: "Email is invalid", message: "")
                return
            }
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    let alert = UIAlertController(title: "Error with email or password", message: e.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let obj: PawpleUserDefaults = PawpleUserDefaults()
                    obj.saveUserState(key: true)
                    User.shared.email = email
                    obj.storeUser()
                    self.navigationController?.dismiss(animated: true)
                }
            }
        }
    }
    
}
