//
//  SearchTableViewCell.swift
//  Pawple
//
//  Created by Hitesh Arora on 12/19/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none

        // Configure the view for the selected state
    }
}
