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
import SDWebImage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    var arrayFavPets: [String] = []
    
    let menuButtonDropdown = DropDown()
    let db = Firestore.firestore()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        self.observeUserSavedProfiles()
        
        setupMenuButtonDropdown()
        
        userImage.layer.masksToBounds = false
        userImage.layer.cornerRadius = userImage.frame.width / 2
        userImage.clipsToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        getLoginState()
        loadProfile()
    }
    
    func getLoginState() {
        if Auth.auth().currentUser == nil {
            handleLogout()
        }
    }
    
    func handleLogout() {
        do {
            try Auth.auth().signOut()
            NotificationCenter.default.post(name: Notification.Name("userSignedOutEvent"), object: nil)
            let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
            let login = storyboard.instantiateViewController(withIdentifier: "loginNC")
            login.modalPresentationStyle = .fullScreen
            self.present(login, animated: true)
        } catch let signOutError as NSError {
            self.alert(title: "Error logging out", message: signOutError.localizedDescription)
        }
    }
    
    func loadProfile() {
        let user = Auth.auth().currentUser
        userImage.sd_setImage(with: user?.photoURL, placeholderImage: UIImage(named: "person.circle"))
        userName.text = user?.displayName
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
            "Log Out"
        ]
        
        menuButtonDropdown.selectionAction = { [weak self] (index, item) in
            //edit profile
            if index == 0 && item == "Edit Profile" {
                if let editProfileVC = self?.storyboard?.instantiateViewController(withIdentifier: "editProfileVC")
                    as? EditProfileViewController {
                    self?.navigationController?.pushViewController(editProfileVC, animated: true)
                    editProfileVC.navigationItem.hidesBackButton = true
                }
            }
            
            //log out
            else if index == 1 && item == "Log Out" {
                self?.handleLogout()
            }
        }
    }
    
    @IBAction func menuButtonClicked(_ sender: UIBarButtonItem) {
        menuButtonDropdown.show()
    }
    
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
//        self.performSegue(withIdentifier: "IndividualResultViewController", sender: index)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ofType: ResultsCollectionViewCell.self, for: indexPath)
        cell.petName.text = ""
//        guard let arrayPhotos = arrayResults[indexPath.item]?.photos
//            else {
//                return cell
//        }
//        if arrayPhotos.count > 0 {
//            cell.petImage.sd_setImage(with: URL(string: (arrayPhotos[0]?.medium)!))
//        }
        return cell
    }


    // This will list the favorite pets
    // 1. Fetch pet ids from Firebase
    // 2. Make API calls to PetFinder to fetch animal based on the id
    // 3.
}

extension ProfileViewController {
    // will access Firebase operations here.

    func getUserProfile () -> DatabaseReference? {

        let dbRef = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        let userProfileRef = dbRef.child("user-savedProfiles").child(uid)
        return userProfileRef
    }

    func observeUserSavedProfiles() {
        if let userProfileRef = self.getUserProfile() {
            userProfileRef.observe(.childAdded) { (snapshot) in
                DispatchQueue.main.async {
                    if let dict = snapshot.value as? [String: Int] {
                        // Here we will make the API call.
                        self.arrayFavPets.append(contentsOf: dict.keys)
//                        self.arrayFavPets = Array(dict.keys)
                    }
                }
            }
            // Listen for deleted comments in the Firebase database

            userProfileRef.observe(.childRemoved) { (snapshot) in
                DispatchQueue.main.async {
                    if let dict = snapshot.value as? [String: Int] {
                        
//                        self.arrayFavPets.r = Array(dict.keys)
                    }
                }
            }
        }
    }
    // Make API calls with the animal id.

}
