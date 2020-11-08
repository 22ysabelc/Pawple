//
//  CommonFunctions.swift
//  Pawple
//
//  Created by 22ysabelc on 8/9/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit

class CommonFunctions: NSObject {
    class func getTimeStamp(timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeZone = .current
//        let localDate = dateFormatter.string(from: date)

        var formattedString = ""
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: Date())
        
        if let year = interval.year, year > 0 {
            if year == 1 {
                formattedString = "1 year ago"
            } else {
                formattedString = "\(year)" + " " + "years ago"
            }
        } else if let month = interval.month, month > 0 {
            if month == 1 {
                formattedString = "1 month ago"
            } else {
                formattedString = "\(month)" + " " + "months ago"
            }
        } else if let day = interval.day, day > 0 {
            if day == 1 {
                formattedString = "1 day ago"
            } else {
                formattedString = "\(day)" + " " + "days ago"
            }
        } else if let hour = interval.hour, hour > 0 {
            if hour == 1 {
                formattedString = "1 hour ago"
            } else {
                formattedString = "\(hour)" + " " + "hours ago"
            }
        } else if let minute = interval.minute, minute > 0 {
            if minute == 1 {
                formattedString = "1 min ago"
            } else {
                formattedString = "\(minute)" + " " + "mins ago"
            }
        } else {
            formattedString = "Just now"
        }
        
        return formattedString
    }
    
    class func imagePicker(objVC: UIViewController, picker: UIImagePickerController) {
        let alert = UIAlertController(title: "Camera or Photo Library?", message: "", preferredStyle: .alert)
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                objVC.present(picker, animated: true, completion: nil)
            } else {
                objVC.alert(title: "Camera is not available", message: "")
            }
        }
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                objVC.present(picker, animated: true, completion: nil)
            } else {
                objVC.alert(title: "Photo Library is not available", message: "")
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            return
        }
        alert.addAction(camera)
        alert.addAction(photoLibrary)
        alert.addAction(cancel)
        objVC.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Save Image
    class func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }

    @objc class func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }


    class func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 280, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 16)]), context: nil)
    }

    // Helper function inserted by Swift 4.2 migrator.
    private class func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
        guard let input = input else { return nil }
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
    }

    // Helper function inserted by Swift 4.2 migrator.
    private class func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
        return input.rawValue
    }


}
