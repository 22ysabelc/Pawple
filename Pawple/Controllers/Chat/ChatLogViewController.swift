//
//  ChatLogViewController.swift
//  Pawple
//
//  Created by 22ysabelc on 8/2/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit
import Firebase

class ChatLogViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    var user: User? = nil
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        
        self.title = user?.name
        
        setUpInputComponents()
        setUpKeyboardObservers()
        
//        collectionview?.keyboardDismissMode = .interactive
        //  TODO: figure out how to move containerView up and down with the keyboard on drag
    
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func setUpInputComponents() {
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(named: "BrandPurple")
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
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
