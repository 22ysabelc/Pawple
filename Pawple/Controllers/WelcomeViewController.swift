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
            print("timer: \(timer)")
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
          print("The user has not signed in before or they have since signed out.")
        } else {
          print("\(error.localizedDescription)")
        }
        return
      }
      // Perform any operations on signed in user here.
//      let userId = user.userID                  // For client-side use only
//      let idToken = user.authentication.idToken // Safe to send to the server
//      let fullName = user.profile.name
//      let givenName = user.profile.givenName
//      let familyName = user.profile.familyName
//      let email = user.profile.email
      // ...
        
        print("Sign in with google, successful sign in")
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
            let authError = error as NSError
            self.alert(title: "Error signing in", message: authError.localizedDescription)
            return
          }
//            print("Sign in with firebase")
//            let user = Auth.auth().currentUser
            
            //from firebase
//            print("userid:", user?.uid)
//            print("name:", user?.displayName)
//            print("photoURL:", user?.photoURL)
//            print("email:", user?.email)
          // User is signed in
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // ...
    }
}
