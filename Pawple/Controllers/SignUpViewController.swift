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
                    self.alert(title: "Error with email or password", message: e.localizedDescription)
                } else {
                    print("AuthResult \(String(describing: authResult))")
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
