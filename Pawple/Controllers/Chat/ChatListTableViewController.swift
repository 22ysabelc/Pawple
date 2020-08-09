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
        
        observeMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
    }
    
    func observeMessages() {
        let dbRef = Database.database().reference().child("messages")
        dbRef.observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message()
                message.fromID = dictionary["fromID"] as? String
                message.toID = dictionary["toID"] as? String
                message.text = dictionary["text"] as? String
                message.timestamp = dictionary["timestamp"] as? Int
                
                if let toID = message.toID {
                    self.messagesDictionary[toID] = message
                    self.messages = Array (self.messagesDictionary.values)
                    self.messages.sort { (message1, message2) -> Bool in
//TODO: get rid of force wrapping
                        return message1.timestamp! > message2.timestamp!
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let objVC = segue.destination as? ChatLogViewController {
            objVC.user = sender as? User
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
        
        cell.message = message
                
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? UserTableViewCell
        performSegue(withIdentifier: "ChatLogVC", sender: cell?.user)
    }
}
