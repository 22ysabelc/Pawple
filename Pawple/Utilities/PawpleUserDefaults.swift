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
}
