//
//  ProfileViewController.swift
//  Pawple
//
//  Created by 22ysabelc on 4/29/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit
import Firebase
import DropDown

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    let menuButtonDropdown = DropDown()
    let db = Firestore.firestore()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMenuButtonDropdown()
        loadProfile()
        
        userImage.layer.masksToBounds = false
        userImage.layer.cornerRadius = userImage.frame.width / 2
        userImage.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getLoginState()
    }
    
    func getLoginState() {
        let obj: PawpleUserDefaults = PawpleUserDefaults()
        if !obj.isUserSignedIn() {
            let storyboard = UIStoryboard(name:"Welcome", bundle: nil)
            let login = storyboard.instantiateViewController(withIdentifier: "loginNC")
            login.modalPresentationStyle = .fullScreen
            self.present(login, animated: true)
        }
    }
    
    //finish this method
//RETRIEVE DATA FROM FIRESTORE (NAMED: "PROFILE" AKA C.FSTORE.PROFILECOLLECTIONNAME)
    func loadProfile() {
        //make image a circle
    }
    
    func customizeDropDown() {
        DropDown.appearance().textColor = UIColor.white
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = #colorLiteral(red: 0.6745098039, green: 0.4352941176, blue: 0.9176470588, alpha: 1)
        DropDown.appearance().selectionBackgroundColor = UIColor.darkGray
        DropDown.appearance().cellHeight = 50
        DropDown.appearance().cornerRadius = 10
        DropDown.appearance().shadowColor = UIColor(white: 0.6, alpha: 1)
        DropDown.appearance().shadowOpacity = 0.9
        DropDown.appearance().shadowRadius = 25
        DropDown.appearance().animationduration = 0.25
    }
    
    func setupMenuButtonDropdown() {
        menuButtonDropdown.direction = .bottom
        menuButtonDropdown.width = 150

        menuButtonDropdown.dismissMode = .onTap
        menuButtonDropdown.anchorView = menuButton

        customizeDropDown()
        
        menuButtonDropdown.bottomOffset = CGPoint(x: 0, y: menuButtonDropdown.bounds.height)
    
        menuButtonDropdown.dataSource = [
            "Edit Profile",
            "Log Out",
        ]
        
        menuButtonDropdown.selectionAction = { [weak self] (index, item) in
            //edit profile
            if index == 0 && item == "Edit Profile" {
                let editProfileVC = self?.storyboard?.instantiateViewController(withIdentifier: "editProfileVC") as! EditProfileViewController
                self?.navigationController?.pushViewController(editProfileVC, animated: true)
                editProfileVC.navigationItem.hidesBackButton = true
            }
            
            //log out
            else if index == 1 && item == "Log Out" {
                do {
                    try Auth.auth().signOut()
                    let obj: PawpleUserDefaults = PawpleUserDefaults()
                    obj.saveUserState(key: false)
                    self?.getLoginState()
                } catch let signOutError as NSError {
                    let alert = UIAlertController(title: "Error logging out", message: signOutError.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(action)
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func menuButtonClicked(_ sender: UIBarButtonItem) {
        menuButtonDropdown.show()
    }
    
}
