//
//  User.swift
//  Pawple
//
//  Created by 22ysabelc on 6/14/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit

public class User: NSObject {
    public static let shared = User()
    public var email: String = ""
    public var name: String = ""
    public var userImage: UIImage?
}
