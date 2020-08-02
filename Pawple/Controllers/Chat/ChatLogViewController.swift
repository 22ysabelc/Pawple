//
//  ChatLogViewController.swift
//  Pawple
//
//  Created by 22ysabelc on 8/2/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit
import Firebase

class ChatLogViewController: UIViewController {

    var user: User? = nil
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarController?.tabBar.isHidden = true
        
        self.title = user?.name
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        print(inputTextField.text)
        saveMessages()
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
                print("Success")
                self.inputTextField.text = ""
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
