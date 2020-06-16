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

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate {
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        userImage.image = croppedImage
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        insertUserInfo()
        
        tabBarController?.tabBar.isHidden = true
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        userImage.layer.masksToBounds = false
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
        
    }
    
    func insertUserInfo() {
        userImage.image = User.shared.userImage ?? UIImage(systemName: "person.circle")
        userName.text = User.shared.name
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    let imagePicker = UIImagePickerController()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image : UIImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!

        picker.dismiss(animated: false, completion: { () -> Void in
            var imageCropVC : RSKImageCropViewController!
            imageCropVC = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.circle)
            imageCropVC.delegate = self
            self.navigationController?.pushViewController(imageCropVC, animated: true)
        })
    }
    
    @IBAction func editProfileImageAction(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Camera or Photo Library?", message: "", preferredStyle: .alert)
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        alert.addAction(camera)
        alert.addAction(photoLibrary)
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        var firebaseDictionary = [String : Any]()
        guard let username = userName.text, username != "" else {
            self.alert(title: "Username is empty", message: "")
            return
        }

        firebaseDictionary[C.FStore.userName] = username

        if let image = userImage.image {
            let data = image.jpegData(compressionQuality: 2.0) ?? Data()
            firebaseDictionary[C.FStore.profileImage] = data
        }

        db.collection(C.FStore.profileCollectionName).addDocument(data:
            firebaseDictionary
        ) { (error) in
            if let e = error {
                //FIX ERROR ABOUT IMAGE BEING MORE THAN ___ BYTES
                self.alert(title: "Error saving data", message: e.localizedDescription)
            }
            else {
                User.shared.name = username
                User.shared.userImage = self.userImage.image
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

}
