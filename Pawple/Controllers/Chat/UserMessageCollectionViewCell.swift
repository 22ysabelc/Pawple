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
    @IBOutlet weak var textView: UITextView! {
        didSet {
//            self.textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }

    func setupCell(message: Message) {
        if let text = message.text {
            self.textView.text = text
            self.textView.isHidden = false
            self.imgView.isHidden = true
            self.imgView.isHidden = true
            self.viewBubble.backgroundColor = UIColor(named: "BrandPurple")
            let originalWidth = self.viewBubble.frame.size.width

            let calculatedWidth = CommonFunctions.estimateFrameForText(text).width + 22
            self.viewBubble.frame.size.width = calculatedWidth
            self.viewBubble.frame.origin.x += (originalWidth - calculatedWidth)

        } else if let imageURL = message.imageURL {
            let photoURL: URL? = URL(string: imageURL)
            self.imgView.sd_setImage(with: photoURL)
            self.imgView.isHidden = false
            self.textView.isHidden = true
            self.viewBubble.backgroundColor = .clear
            self.viewBubble.frame.size.width = 280
        }
    }
    
    @IBOutlet weak var viewBubble: UIView! {
        didSet {
            //TODO: adjust to liking
            self.viewBubble.layer.cornerRadius = 16
        }
    }
    
}
