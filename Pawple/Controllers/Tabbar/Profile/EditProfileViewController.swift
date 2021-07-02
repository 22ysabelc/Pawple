//
//  EditProfileViewController.swift
//  Pawple
//
//  Created by 22ysabelc on 5/5/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit
import Firebase
import CoreML
import Vision
import RSKImageCropper
import FirebaseStorage

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate {
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        userImage.image = croppedImage
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var userImage: UIImageView! {
        didSet {
            self.userImage.layer.cornerRadius = self.userImage.frame.height / 2
        }
    }
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        
        imagePicker.delegate = self
        
        userImage.layer.masksToBounds = false
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
        
        insertUserInfo()
    }
    
    func insertUserInfo() {
        let user = Auth.auth().currentUser
        if user?.photoURL != nil {
            userImage.sd_setImage(with: user?.photoURL, placeholderImage: UIImage(named: "person.circle"))
        } else {
            userImage.image = UIImage(systemName: "person.circle")
        }
        userName.text = user?.displayName
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    let imagePicker = UIImagePickerController()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
        info: [UIImagePickerController.InfoKey: Any]) {
        
        let image: UIImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
        
        picker.dismiss(animated: false, completion: { () -> Void in
            var imageCropVC: RSKImageCropViewController!
            imageCropVC = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.circle)
            imageCropVC.delegate = self
            self.navigationController?.pushViewController(imageCropVC, animated: true)
        })
    }
    
    @IBAction func editProfileImageAction(_ sender: UITapGestureRecognizer) {
        CommonFunctions.imagePicker(objVC: self, picker: imagePicker)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        activityIndicator.isHidden = false
        
        guard let username = userName.text, username != "" else {
            activityIndicator.isHidden = true
            self.alert(title: "Name is empty", message: "")
            return
        }
        
        if let uploadData = userImage.image?.jpegData(compressionQuality: 0.2) {
            let storageRef = Storage.storage().reference()
            if let userID = Auth.auth().currentUser?.uid {
                let spaceRef = storageRef.child(String(format: "ProfilePictures/%@.jpeg", userID))
                
                spaceRef.putData(uploadData, metadata: nil) { (metadata, _) in
                    guard metadata != nil else {
                        self.activityIndicator.isHidden = true
                        return
                    }
                    spaceRef.downloadURL { (url, _) in
                        guard let downloadURL = url else {
                            self.activityIndicator.isHidden = true
                            return
                        }
                        self.updateProfileWithName(name: username, photoURL: downloadURL)
                    }
                }
            }
        }
    }
    
    private func updateProfileWithName(name: String, photoURL: URL) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.photoURL = photoURL
        changeRequest?.commitChanges { (error) in
            if error != nil {
                self.alert(title: "Error updating profile", message: error?.localizedDescription)
                self.activityIndicator.isHidden = true
                return
            }
            self.activityIndicator.isHidden = true
            self.userImage.sd_setImage(with: photoURL, placeholderImage: UIImage(named: "person.circle"))
            self.navigationController?.popViewController(animated: true)
        }
    }
}
