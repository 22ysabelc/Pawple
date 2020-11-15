//
//  UserMessageCollectionViewself.swift
//  Pawple
//
//  Created by 22ysabelc on 8/30/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit

class UserMessageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView! {
        didSet {
            self.imgView.layer.cornerRadius = 16
        }
    }
    @IBOutlet weak var textView: UITextView!

    func setUpCell(message: Message, objVC: UIViewController) {
        if let text = message.text {
            self.textView.text = text
            self.textView.isHidden = false
            self.imgView.isHidden = true
            self.imgView.isHidden = true
            self.viewBubble.isHidden = false
            let originalWidth = self.viewBubble.frame.size.width

            let calculatedWidth = CommonFunctions.estimateFrameForText(text).width + 22
            self.viewBubble.frame.size.width = calculatedWidth
            self.viewBubble.frame.origin.x += (originalWidth - calculatedWidth)

        } else if let imageURL = message.imageURL {
            let photoURL: URL? = URL(string: imageURL)
            self.imgView.sd_setImage(with: photoURL)
            self.imgView.isHidden = false
            self.textView.isHidden = true
            self.viewBubble.isHidden = true
            self.viewBubble.frame.size.width = 280
            let longpressGestureRecognizer = UILongPressGestureRecognizer(target: objVC, action: #selector(saveImageGesture(_:)))
            imgView.isUserInteractionEnabled = true
            imgView.addGestureRecognizer(longpressGestureRecognizer)
        }
    }
    
    @IBOutlet weak var viewBubble: UIView! {
        didSet {
            self.viewBubble.layer.cornerRadius = 16
        }
    }
    
    @objc func saveImageGesture(_ sender: UILongPressGestureRecognizer) {
    }
    
}
