//
//  FilterViewCell.swift
//  CollectionViewDynamicSizing
//
//  Created by Hitesh Arora on 12/12/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit

class FilterViewCell: UICollectionViewCell {
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var viewFilterImage: UIImageView!
    
    @IBOutlet weak var labelFilterName: UILabel!
    
    override func awakeFromNib() {
        viewFilter.addGrayBorderAndCorner()
    }
}

extension UIView {
    func addGrayBorderAndCorner() {
        layer.cornerRadius = 8
    }
}
