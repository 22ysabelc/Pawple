//
//  ResultsCollectionVC.swift
//  Pawple
//
//  Created by 22ysabelc on 12/31/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit

class ResultsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petName: UILabel! {
        didSet {
            self.petName.layer.cornerRadius = self.petName.frame.height/2
            self.petName.clipsToBounds = true
        }
    }
}
