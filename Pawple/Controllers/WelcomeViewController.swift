//
//  ViewController.swift
//  Pawple
//
//  Created by 22ysabelc on 4/22/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit
import CLTypingLabel
import GoogleSignIn
import Firebase

class WelcomeViewController: UIViewController {
        
    @IBOutlet weak var welcomeText: CLTypingLabel!
    @IBOutlet weak var pawpleText: CLTypingLabel!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        welcomeText.text = "    Welcome to"
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer) in
            self.pawpleText.text = " Pawple "
        }
    }
}

//MARK: - Google Sign In
extension WelcomeViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
      if let error = error {
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
          alert(title: "The user has not signed in before or they have since signed out.", message: "")
        } else {
          alert(title: "Error signing in", message: error.localizedDescription)
        }
        return
      }
        
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
            let authError = error as NSError
            self.alert(title: "Error signing in", message: authError.localizedDescription)
            return
          }
            
            let user = Auth.auth().currentUser
            
            guard let uid = user?.uid else {
                return
            }
            
            var values = [String: Any]()
            if let photoURL = user?.photoURL {
                values["photoURL"] = photoURL.absoluteString
            }
            let databaseRef = Database.database().reference()
            let userRef = databaseRef.child("users").child(uid)
            if let name = user?.displayName, let email = user?.email {
                values["name"] = name
                values["email"] = email
                userRef.updateChildValues(values) { (error, databaseReference) in
                    if error != nil {
                        self.alert(title: "Error updating database", message: error?.localizedDescription)
                        return
                    }
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // ...
    }
}
