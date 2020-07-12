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
    
//TODO: go to edit profile view controller
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
                    self.navigationController?.dismiss(animated: true)
                }
            }
            
            //Saves in firebase storage, but needs name and profile image
//            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
//
//                if error != nil {
//                    print(error!)
//                    return
//                }
//
//                guard let uid = user?.user.uid else {
//                    return
//                }
//
//                //successfully authenticated user
//                let imageName = UUID().uuidString
//                let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
//
//                if let profileImage = self.profileImageView.image, let uploadData = profileImage.jpegData(compressionQuality: 0.1) {
//
//                    storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
//
//                        if let error = error {
//                            print(error)
//                            return
//                        }
//
//                        storageRef.downloadURL(completion: { (url, err) in
//                            if let err = err {
//                                print(err)
//                                return
//                            }
//
//                            guard let url = url else { return }
//                            let values = ["name": name, "email": email, "profileImageUrl": url.absoluteString]
//
//                            self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
//                        })
//
//                    })
//                }
//            })
        }
    }
    
}
