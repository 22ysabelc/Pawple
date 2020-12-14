//
//  FilterViewCell.swift
//  CollectionViewDynamicSizing
//
//  Created by Shankar on 13/03/20.
//  Copyright © 2020 Shankar. All rights reserved.
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
