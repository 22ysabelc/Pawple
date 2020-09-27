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
    var isRead: Bool?
    var messageID: String?
    var imageURL: String?
    
    func initWithDictionary(dictionary: [String: AnyObject], messageID: String) -> Message {
        self.fromID = dictionary["fromID"] as? String
        self.toID = dictionary["toID"] as? String
        self.text = dictionary["text"] as? String
        self.timestamp = dictionary["timestamp"] as? Int
        self.isRead = dictionary["isRead"] as? Bool
        self.messageID = messageID
        self.imageURL = dictionary["imageURL"] as? String
        return self
    }
    
    func chatPartnerId() -> String? {
        return fromID == Auth.auth().currentUser?.uid ? toID : fromID
    }
    
    func updateMessageToRead() {
        let dbRef = Database.database().reference()
        var dictionary = [String: Any]()
        if let msgID = self.messageID {
            let messagesRef = dbRef.child("messages").child(msgID)
            dictionary["isRead"] = true
            messagesRef.updateChildValues(dictionary)
        }
    }
    
    func deleteMessage() {
        let dbRef = Database.database().reference()
        if let msgID = self.messageID {
            let messageRef = dbRef.child("messages").child(msgID)
            messageRef.removeValue()
        }
    }
}
