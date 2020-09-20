//
//  UserTableViewCell.swift
//  Pawple
//
//  Created by 22ysabelc on 7/12/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit
import Firebase

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var isRead: UIImageView!
    
    var user = User()
    
    var message: Message?
    
    func setUpCellWithMessage(_ message: Message) {
        if let chatPartnerId = message.chatPartnerId() {
            let userRef = Database.database().reference().child("users").child(chatPartnerId)
            userRef.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let user = User().initWithDictionary(dictionary: dictionary)
                    user.uid = snapshot.key
                    self.user = user
                    self.name.text = user.name
                    
                    let photoURL: URL? = URL(string: user.photoURL ?? "")
                    self.userImageView.sd_setImage(with: photoURL, placeholderImage: UIImage(named: "person.circle"))
                }
            }
        }
        self.subtitle.text = message.text
        self.isRead.isHidden = message.isRead ?? true
        if let timestamp = message.timestamp {
            self.timestamp.text = CommonFunctions.getTimeStamp(timestamp: timestamp)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userImageView.layer.cornerRadius = self.userImageView.frame.height / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCellWithUser(user: User) {
        self.name.text = user.name
        self.subtitle.text = user.email
        
        let photoURL: URL? = URL(string: user.photoURL ?? "")
        self.userImageView.sd_setImage(with: photoURL, placeholderImage: UIImage(named: "person.circle"))
    }
}
