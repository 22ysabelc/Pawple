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
    @IBOutlet weak var editImage: UIButton!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        insertUserInfo()
        
        tabBarController?.tabBar.isHidden = true
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        userImage.layer.masksToBounds = false
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
        
    }
    
    func insertUserInfo() {
        
    }
    
    @IBAction func editProfileImageAction(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
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
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        //DOES IT ADD ANOTHER DICTIONARY OR UPDATE USER'S INFO???

        var firebaseDictionary = [String : Any]()
        guard let username = userName.text, username != "" else {
            let alert = UIAlertController(title: "Username is empty", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
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
                let alert = UIAlertController(title: "Error saving data", message: e.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                User.shared.name = username
                User.shared.userImage = self.userImage.image
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

}
