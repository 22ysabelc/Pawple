//
//  Message.swift
//  Pawple
//
//  Created by 22ysabelc on 8/9/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var fromID: String?
    var toID: String?
    var text: String?
    var timestamp: Int?
    
    func initWithDictionary(dictionary: [String: AnyObject]) -> Message {
        self.fromID = dictionary["fromID"] as? String
        self.toID = dictionary["toID"] as? String
        self.text = dictionary["text"] as? String
        self.timestamp = dictionary["timestamp"] as? Int
        return self
    }
    
    func chatPartnerId() -> String? {
        return fromID == Auth.auth().currentUser?.uid ? toID : fromID
    }
}
