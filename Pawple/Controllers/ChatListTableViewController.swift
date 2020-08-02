//
//  MessageListTableViewController.swift
//  Pawple
//
//  Created by 22ysabelc on 6/16/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit

class ChatListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToChat", sender: self)
    }
    
}
