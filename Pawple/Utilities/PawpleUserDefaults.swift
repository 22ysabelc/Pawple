//
//  UserDefaults.swift
//  Pawple
//
//  Created by 22ysabelc on 5/23/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import Foundation

//can save Strings (eg: username)
struct PawpleUserDefaults {
    public func saveUserState(key: Bool) {
        UserDefaults.standard.set(key, forKey: "isUserSignedIn")
    }

    public func isUserSignedIn() -> Bool {
        UserDefaults.standard.bool(forKey: "isUserSignedIn")
    }
    
    public func storeUser() {
        UserDefaults.standard.set(User.shared.email, forKey: "emailID")
        UserDefaults.standard.set(User.shared.name, forKey: "username")
    }
    
    public func getUser() {
        if let emailID = UserDefaults.standard.object(forKey: "emailID") {
            User.shared.email = emailID as! String
        }
        if let username = UserDefaults.standard.object(forKey: "username") {
            User.shared.name = username as! String
        }
    }
}
