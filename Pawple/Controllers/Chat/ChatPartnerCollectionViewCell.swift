//
//  ChatPartnerCollectionViewCell.swift
//  Pawple
//
//  Created by 22ysabelc on 8/30/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit

class ChatPartnerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            self.textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        }
    }
    
    @IBOutlet weak var viewBubble: UIView! {
        didSet {
            //TODO: adjust to liking
            self.viewBubble.layer.cornerRadius = 16
        }
    }
    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
        }
    }
}
