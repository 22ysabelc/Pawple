//
//  UserMessageCollectionViewCell.swift
//  Pawple
//
//  Created by 22ysabelc on 8/30/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit

class UserMessageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var viewBubble: UIView! {
        didSet {
            //TODO: adjust to liking
            self.viewBubble.layer.cornerRadius = 15
        }
    }
    
}
