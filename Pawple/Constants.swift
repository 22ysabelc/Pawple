//
//  Constants.swift
//  Pawple
//
//  Created by 22ysabelc on 5/5/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import Foundation

struct C {
    
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    
    struct FStore {
        static let profileCollectionName = "profile"
        static let userName = "name"
        static let profileImage = "profileImage"
        
        static let chatCollectionName = "messages"
        static let senderField = "sender"
        static let messageTextField = "text"
        static let messageDateField = "date"
    }
}
