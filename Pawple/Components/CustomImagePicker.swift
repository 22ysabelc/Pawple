//
//  CustomImagePicker.swift
//  Pawple
//
//  Created by 22ysabelc on 6/12/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import Foundation
import Photos
import UIKit

public class CustomImagePicker: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public static let shared = CustomImagePicker()
    let imagePicker = UIImagePickerController()

    public var imageSelected: (UIImagePickerController, UIImage) -> Void = {_, _  in}
    public var canceled: (UIImagePickerController) -> Void = {_ in }

    public func present(vc: UIViewController, source: UIImagePickerController.SourceType) {

        self.imagePicker.navigationBar.barTintColor = UIColor(named: "deepSeaBlue")
        self.imagePicker.navigationBar.isTranslucent = false
        self.imagePicker.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.imagePicker.navigationBar.tintColor = .white

        self.imagePicker.sourceType = source
        self.imagePicker.allowsEditing = false
        self.imagePicker.delegate = self
        vc.present(self.imagePicker, animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.imageSelected(picker, image)
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.canceled(picker)
        picker.dismiss(animated: true, completion: nil)
    }
}
