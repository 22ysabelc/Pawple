//
//  User.swift
//  Pawple
//
//  Created by 22ysabelc on 6/14/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit

public class User: NSObject {
    public var email: String?
    public var name: String?
    public var photoURL: String?
    public var uid: String?
    
    func initWithDictionary(dictionary: [String: AnyObject]) -> User {
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.photoURL = dictionary["photoURL"] as? String
        return self
    }
}
