//
//  FilterCollectionHeaderView.swift
//  CollectionViewDynamicSizing
//
//  Created by Hitesh Arora on 12/12/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit

class FilterCollectionHeaderView: UICollectionReusableView {
    @IBOutlet weak var title: UILabel!
    
}

class FilterCollectionFooterView: UICollectionReusableView {
    @IBOutlet weak var findAPetButton: UIButton! {
        didSet {
            self.findAPetButton.layer.cornerRadius = self.findAPetButton.frame.height / 2
        }
    }
}
