//
//  UsersTableViewController.swift
//  Pawple
//
//  Created by 22ysabelc on 7/12/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

//TODO: userID in fetchUser(), add to dictionary
class UsersTableViewController: UITableViewController {

    let databaseRef = Database.database().reference()
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
    }
    
    func fetchUser() {
        databaseRef.child("users").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: String] {
                let user = User()
                user.name = dictionary["name"]
                user.email = dictionary["email"]
                user.photoURL = dictionary["photoURL"]
                user.uid = snapshot.key
                self.users.append(user)
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let objVC = segue.destination as? ChatLogCollectionViewController {
            objVC.user = sender as? User
        }
    }
}

extension UsersTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        let user = self.users[indexPath.row]
        
        cell.configureCellWithUser(user: user)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ChatLogCollectionVC", sender: users[indexPath.row])
    }
}
