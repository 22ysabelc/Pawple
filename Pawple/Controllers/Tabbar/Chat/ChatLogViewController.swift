//
//  ChatLogViewController.swift
//  Pawple
//
//  Created by 22ysabelc on 8/2/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit
import Firebase

class ChatLogViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {

    let imagePicker = UIImagePickerController()
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    var lastIndexChatPartner: Int = 0
    var user: User? {
        didSet {
            observeUserMessages()
        }
    }

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

        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        self.definesPresentationContext = true
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
        guard let uid = Auth.auth().currentUser?.uid, let partnerUID = self.user?.uid else {
            return
        }
        let dbRef = Database.database().reference()
        let userMessagesRef = dbRef.child("user-messages").child(uid).child(partnerUID)
        userMessagesRef.observe(.childAdded) { (snapshot) in
            let messageID = snapshot.key
            let messageRef = dbRef.child("messages").child(messageID)
            messageRef.observeSingleEvent(of: .value) { (snapshot) in

                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = Message().initWithDictionary(dictionary: dictionary, messageID: messageID)
                    if self.messages.last?.messageID != message.messageID {
                        self.messages.append(message)
                    }
                    self.returnLastIndexChatPartner()
                    self.messages.last?.updateMessageToRead()
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.scrollToBottom()
                    }
                }
            }
        }
    }

    func returnLastIndexChatPartner() {
        let message = messages.last {
            element in
            return element.fromID == self.user?.uid
        }
        if let msg = message {
            lastIndexChatPartner = messages.lastIndex(of: msg) ?? 0
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
            sendTextMessage()
        }
    }

    func sendTextMessage() {
        if let message = inputTextField.text {
            var properties = [String: Any]()
            properties["text"] = message
            sendMessageToFirebase(properties: properties)
        }
    }


    @IBAction func uploadPhotoButton(_ sender: UIButton) {
        CommonFunctions.imagePicker(objVC: self, picker: imagePicker)
    }

    private func sendMessageToFirebase(properties: [String: Any]) {
        let databaseRef = Database.database().reference()
        let messagesRef = databaseRef.child("messages").childByAutoId()
        var dictionary = [String: Any]()
        dictionary["fromID"] = Auth.auth().currentUser?.uid
        dictionary["toID"] = self.user?.uid
        dictionary["timestamp"] = Int(Date().timeIntervalSince1970)
        dictionary["isRead"] = false

        // $0 -> key, $1 -> value
        properties.forEach { (dictionary[$0] = $1) }
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
            let fromIDRef = userMessagesRef.child(userID).child(recipientUserID)
            let recipientIDRef = userMessagesRef.child(recipientUserID).child(userID)
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

extension ChatLogViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
        info: [UIImagePickerController.InfoKey: Any]) {

        let image: UIImage = (info[UIImagePickerController.InfoKey.editedImage] as? UIImage)!

        picker.dismiss(animated: false, completion: { () -> Void in
            if let uploadData = image.jpegData(compressionQuality: 0.2) {
                let storageRef = Storage.storage().reference()
                let imageName = NSUUID().uuidString
                let spaceRef = storageRef.child(String(format: "MessageImages/%@.jpeg", imageName))

                spaceRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    guard metadata != nil else {
                        return
                    }
                    spaceRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            return
                        }
                        if let error = error {
                            print(error)
                        } else if let url = url {
                            print(url)
                        }
                        self.sendImageMessage(imageURL: downloadURL.absoluteString, width: Float(image.size.width), height: Float(image.size.height))
                    }
                }
            }
        })
    }

    private func sendImageMessage(imageURL: String, width: Float, height: Float) {
        var properties = [String: Any]()
        properties["imageURL"] = imageURL
        properties["imageWidth"] = width
        properties["imageHeight"] = height
        sendMessageToFirebase(properties: properties)
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

        var height: CGFloat = 80
        let message = messages[indexPath.item]
        let width = view.frame.width

        if let imageWidth = message.imageWidth, let imageHeight = message.imageHeight {
            height = CGFloat(imageHeight / imageWidth * 280)
        } else if let text = message.text {
            height = CommonFunctions.estimateFrameForText(text).height + 30
        }
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = messages[indexPath.item]
        if message.fromID == Auth.auth().currentUser?.uid {
            let cell: UserMessageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserMessageCollectionViewCell", for: indexPath) as! UserMessageCollectionViewCell
            cell.setUpCell(message: message, objVC: self)
            return cell
        } else {
            let cell: ChatPartnerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatPartnerCollectionViewCell", for: indexPath) as! ChatPartnerCollectionViewCell
            cell.setUpCell(message: message, indexPath: indexPath, objVC: self)
            return cell
        }
    }
}

//MARK - SAVE IMAGE
extension ChatLogViewController {
    @IBAction func saveImageGesture(_ sender: UILongPressGestureRecognizer) {
        if let imageView = sender.view as? UIImageView, let image = imageView.image, sender.state == UIGestureRecognizer.State.began {
            let alert = UIAlertController(title: "Save Image to Photo Library", message: "", preferredStyle: .alert)
            let save = UIAlertAction(title: "Save", style: .default) { _ in
                CommonFunctions.writeToPhotoAlbum(image: image)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                return
            }
            alert.addAction(save)
            alert.addAction(cancel)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
