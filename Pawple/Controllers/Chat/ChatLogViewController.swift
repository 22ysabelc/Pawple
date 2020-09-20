//
//  ChatLogViewController.swift
//  Pawple
//
//  Created by 22ysabelc on 8/2/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit
import Firebase

class ChatLogViewController: UIViewController, UITextFieldDelegate {
    
    var user: User? {
        didSet {
            observeUserMessages()
        }
    }
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        
        self.title = user?.name
        
        setUpInputComponents()
        setUpKeyboardObservers()
        
        collectionView.isScrollEnabled = true
        collectionView.keyboardDismissMode = .interactive
        //  TODO: figure out how to move containerView up and down with the keyboard on drag
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        scrollToBottom()
    }
    
    private func scrollToBottom() {
        let item = self.collectionView(self.collectionView, numberOfItemsInSection: 1) - 1
        let lastItemIndex = NSIndexPath(item: item, section: 0)
        self.collectionView.scrollToItem(at: lastItemIndex as IndexPath, at: .top, animated: true)
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let dbRef = Database.database().reference()
        let userMessagesRef = dbRef.child("user-messages").child(uid)
        userMessagesRef.observe(.childAdded) { (snapshot) in
            let messageID = snapshot.key
            let messageRef = dbRef.child("messages").child(messageID)
            messageRef.observe(.value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = Message().initWithDictionary(dictionary: dictionary, messageID: messageID)
                    if message.chatPartnerId() == self.user?.uid {
                        if self.messages.last?.messageID != message.messageID {
                            self.messages.append(message)
                        }
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            let message = self.messages.last
                            message?.updateMessageToRead()
                            self.scrollToBottom()
                        }
                    }
                }
            }
        }
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func setUpInputComponents() {
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
    }
    
    func setUpKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    //TODO: fix duration for going up
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        if let height = keyboardFrame?.height {
            containerViewBottomAnchor?.constant = -height + view.safeAreaInsets.bottom
        }
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
            self.scrollToBottom()
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        containerViewBottomAnchor?.constant = view.safeAreaInsets.bottom
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if inputTextField.text != "" {
            saveMessages()
        }
    }
    
    func saveMessages() {
        let databaseRef = Database.database().reference()
        let messagesRef = databaseRef.child("messages").childByAutoId()
        if let message = inputTextField.text {
            var dictionary = [String: Any]()
            dictionary["fromID"] = Auth.auth().currentUser?.uid
            dictionary["toID"] = self.user?.uid
            dictionary["text"] = message
            dictionary["timestamp"] = Int(Date().timeIntervalSince1970)
            dictionary["isRead"] = false
            messagesRef.updateChildValues(dictionary) { (error, databaseReference) in
                if error != nil {
                    self.alert(title: "Error updating database", message: error?.localizedDescription)
                    return
                }
                guard let userID = Auth.auth().currentUser?.uid else {
                    return
                }
                guard let recipientUserID = self.user?.uid else {
                    return
                }
                let userMessagesRef = databaseRef.child("user-messages")
                let fromIDRef = userMessagesRef.child(userID)
                let recipientIDRef = userMessagesRef.child(recipientUserID)
                if let messageID = messagesRef.key {
                    var dict = [String: Any]()
                    dict[messageID] = 1
                    fromIDRef.updateChildValues(dict) { (error, databaseReference) in
                        if error != nil {
                            self.alert(title: "Error updating database for user messages", message: error?.localizedDescription)
                            return
                        }
                    }
                    recipientIDRef.updateChildValues(dict)
                }
                self.inputTextField.text = ""
            }
        }
    }
}

extension ChatLogViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = messages[indexPath.row]
        if message.fromID == Auth.auth().currentUser?.uid {
            let cell: UserMessageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserMessageCollectionViewCell", for: indexPath) as! UserMessageCollectionViewCell
            cell.textView.text = message.text
            return cell
        } else {
            let cell: ChatPartnerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatPartnerCollectionViewCell", for: indexPath) as! ChatPartnerCollectionViewCell
            cell.textView.text = message.text
            
            let index = indexPath.row
            cell.profileImage.isHidden = false
            if index > 0 {
                let fromID = messages[index-1].fromID
                if fromID == message.chatPartnerId() {
                    cell.profileImage.isHidden = true
                }
            }
            
            let photoURL: URL? = URL(string: self.user?.photoURL ?? "")
            cell.profileImage.sd_setImage(with: photoURL, placeholderImage: UIImage(named: "person.circle"))
            
            return cell
            
        }
    }
    
}
