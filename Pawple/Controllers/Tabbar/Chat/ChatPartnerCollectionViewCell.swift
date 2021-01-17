//
//  ChatPartnerCollectionViewself.swift
//  Pawple
//
//  Created by 22ysabelc on 8/30/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit

class ChatPartnerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView! {
        didSet {
            self.imgView.layer.cornerRadius = 16
        }
    }
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var viewBubble: UIView! {
        didSet {
            self.viewBubble.layer.cornerRadius = 16
        }
    }
    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
        }
    }
    
    func setUpCell(message: Message, indexPath: IndexPath, objVC: ChatLogViewController) {
        if let text = message.text {
            self.textView.text = text
            self.textView.isHidden = false
            self.imgView.isHidden = true
            self.viewBubble.isHidden = false

            let calculatedWidth = CommonFunctions.estimateFrameForText(text).width + 22
            self.viewBubble.frame.size.width = calculatedWidth
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

        if indexPath.item == objVC.lastIndexChatPartner {
            self.profileImage.isHidden = false
        } else {
            self.profileImage.isHidden = true
        }

        let photoURL: URL? = URL(string: objVC.user?.photoURL ?? "")
        self.profileImage.sd_setImage(with: photoURL, placeholderImage: UIImage(named: "person.circle"))
    }
    
    @objc func saveImageGesture(_ sender: UILongPressGestureRecognizer) {
    }
}
