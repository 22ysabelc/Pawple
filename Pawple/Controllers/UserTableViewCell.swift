//
//  UserTableViewCell.swift
//  Pawple
//
//  Created by 22ysabelc on 7/12/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userImageView.layer.cornerRadius = self.userImageView.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellWithUser(user: User) {
        self.name.text = user.name
        self.email.text = user.email
        
        let photoURL: URL? = URL(string: user.photoURL ?? "")
        self.userImageView.sd_setImage(with: photoURL, placeholderImage: UIImage(named: "person.circle"))
    }

}
