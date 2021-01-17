//
//  MessageListTableViewController.swift
//  Pawple
//
//  Created by 22ysabelc on 6/16/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit
import Firebase

class ChatListTableViewController: UITableViewController {
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(userSignedOut), name: Notification.Name(rawValue: "userSignedOutEvent"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
        
        observeUserMessages()
    }
    
    @objc func userSignedOut(notification: NSNotification) {
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let dbRef = Database.database().reference()
        let userMessagesRef = dbRef.child("user-messages").child(uid)
        userMessagesRef.observe(.childAdded) { (snapshot) in
            let recipientUID = snapshot.key
            userMessagesRef.child(recipientUID).observe(.childAdded) { (snapshot) in
                dbRef.child("messages").child(snapshot.key).observe(.value) { (snapshot) in
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let message = Message().initWithDictionary(dictionary: dictionary, messageID: snapshot.key)
                        if let chatPartnerId = message.chatPartnerId() {
                            self.messagesDictionary[chatPartnerId] = message
                        }
                        self.handleTableViewReload()
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let objVC = segue.destination as? ChatLogViewController {
            objVC.user = sender as? User
        }
    }
    
    private func handleTableViewReload() {
        self.messages = Array (self.messagesDictionary.values)
        self.messages.sort { (message1, message2) -> Bool in
            if let timestamp1 = message1.timestamp, let timestamp2 = message2.timestamp {
                return timestamp1 > timestamp2
            }
            return true
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ChatListTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        let message = self.messages[indexPath.row]
        
        cell.setUpCellWithMessage(message)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? UserTableViewCell
        
        let message = self.messages[indexPath.row]
        message.updateMessageToRead()
        
        performSegue(withIdentifier: "ChatLogVC", sender: cell?.user)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let uid = Auth.auth().currentUser?.uid {
                let message = messages[indexPath.row]
                if let chatPartnerId = message.chatPartnerId() {
                    Database.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue { (error, dbReference) in
                        if error != nil {
                            self.alert(title: "Error", message: "Failed to delete chat")
                            return
                        }
                        self.messagesDictionary.removeValue(forKey: chatPartnerId)
                        self.messages.remove(at: indexPath.row)
                        DispatchQueue.main.async {
                            self.tableView.deleteRows(at: [indexPath], with: .top)
                        }
                    }
                }
            }
        }
    }
}
