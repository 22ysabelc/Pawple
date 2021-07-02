//
//  IndividualResultViewController.swift
//  Pawple
//
//  Created by 22ysabelc on 2/6/21.
//  Copyright © 2021 Ysabel Chen. All rights reserved.
//

import UIKit
import Firebase

class IndividualResultViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var petName: UILabel! {
        didSet {
            self.petName.layer.cornerRadius = self.petName.frame.height/6
            self.petName.clipsToBounds = true
        }
    }
    var isAnimalProfileFavorite: Bool = false
    
    @IBOutlet weak var petDescription: UITextView! {
        didSet {
            self.petDescription.layer.borderWidth = 2.5
            self.petDescription.layer.borderColor = UIColor.systemPurple.cgColor
            self.petDescription.layer.cornerRadius = self.petDescription.frame.height/8
        }
    }
    
    @IBOutlet weak var petGeneralInfo: UILabel! {
        didSet {
            self.petGeneralInfo.layer.borderWidth = 2.5
            self.petGeneralInfo.layer.borderColor = UIColor.systemPurple.cgColor
            self.petGeneralInfo.layer.cornerRadius = self.petGeneralInfo.frame.height/4
        }
    }
    
    @IBOutlet weak var chatShelter: UIButton! {
        didSet {
            self.chatShelter.layer.cornerRadius = self.chatShelter.frame.height/2
        }
    }
    
    @IBOutlet weak var saveProfile: UIButton! {
        didSet {
            self.saveProfile.layer.cornerRadius = self.saveProfile.frame.height/2
        }
    }
    
    @IBOutlet weak var submitForm: UIButton! {
        didSet {
            self.submitForm.layer.cornerRadius = self.submitForm.frame.height/3
        }
    }
    
    var details: AnimalDetails?
    var org: OrgDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveProfile.titleLabel?.numberOfLines = 0

        setDetails()
        self.observeUserSavedProfiles()
    }

    func setDetails() {
        self.petName.text = details?.name
        if details?.photos.count ?? 0 > 0, let image = details?.photos[0]?.medium {
            self.profileImage.sd_setImage(with: URL(string: image))
        }
        self.petGeneralInfo.text = setGeneralInfo()
        setPetDescription()
    }
    
    func setGeneralInfo() -> String {
        var breedString = "Breed: "
        if let breed = details?.breeds?.primary {
            breedString += "\(breed)"
            if let mixed = details?.breeds?.mixed {
                if mixed {
                    breedString += " mix"
                }
            }
        } else {
            breedString += "Not listed"
        }
        var genderString = "Gender: "
        if let gender = details?.gender {
            genderString += "\(gender)"
        } else {
            genderString += "Not listed"
        }
        var sizeString = "Size: "
        if let size = details?.size {
            sizeString += "\(size)"
        } else {
            sizeString += "Not listed"
        }
        var ageString = "Age: "
        if let age = details?.age {
            if age.contains("Baby") {
                if let type = details?.type {
                    if type.contains("Dog") {
                        ageString += "Puppy"
                    } else {
                        ageString += "Kitten"
                    }
                }
            } else {
                ageString += "\(age)"
            }
        } else {
            ageString += "Not listed"
        }
        
        let generalInfo = breedString + "\n" + genderString + "\n" + sizeString + "\n" + ageString
        return generalInfo
    }
    
    func setPetDescription() {
        var locationString = ""
        if let location = details?.contact {
            if let address = location.address {
                if let city = address.city, let state = address.state {
                    locationString += city + ", " + state
                }
            }
        } else {
            locationString += "Location not listed"
        }
        var description = ""
        if let desc = details?.desc, let profileURL = details?.profileURL {
            description = "\(desc) \n\n \(profileURL)" + "\n" + "Powered by PetFinder"
        } else {
            description = "No description"
        }
        getOrgName { (name) in
            let petDescription = name + "\n" + locationString + "\n" + "\n" + description
            self.petDescription.text = petDescription
        }
    }
    
    func getOrgName(completion: @escaping (String) -> Void) {
        if let orgId = details?.organization_id {
            APIServiceManager.shared.fetchOrganizationDetails(orgId: orgId) { (organizationDetails) in
                self.org = organizationDetails
                if let name = self.org?.name {
                    completion(name)
                } else {
                    completion("Organization not listed")
                }
            }
        }
    }

    @IBAction func savePetProfile(_ sender: Any) {
        if self.isAnimalProfileFavorite {
            self.removePetFromFavorites()
        } else {
            self.addPetToFavorites()
        }
    }

    func changeFavStatus (isFav: Bool) {
        if isFav {
            self.saveProfile.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            self.saveProfile.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        self.isAnimalProfileFavorite = isFav
    }
}


extension IndividualResultViewController {
    // Firebase stuff

    func observeUserSavedProfiles() {
        if let userProfileRef = self.getUserProfile(), let animalId = self.details?.id {
            userProfileRef.observe(.value) { (snapshot) in
                DispatchQueue.main.async {
                    if snapshot.hasChild("\(animalId)") {
                        self.changeFavStatus(isFav: true)
                    } else {
                        self.changeFavStatus(isFav: false)
                    }
                }
            }
        }
    }

    func addPetToFavorites() {
        if let userProfileRef = self.getUserProfile(), let animalId = self.details?.id {
            var dict = [String: Any]()
            dict["\(animalId)"] = 1
            userProfileRef.updateChildValues(dict) { (error, _) in
                if error != nil {
                    self.alert(title: "Error updating database for user saved profiles", message: error?.localizedDescription)
                    return
                }
            }
        }
    }

    func removePetFromFavorites() {
        if let userProfileRef = self.getUserProfile(), let animalId = self.details?.id {
            userProfileRef.child("\(animalId)").removeValue { (error, _) in
                if error != nil {
                    self.alert(title: "Error", message: "Failed to remove profile from favorites")
                    return
                }
            }
        }
    }

    func getUserProfile () -> DatabaseReference? {

        let dbRef = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        let userProfileRef = dbRef.child("user-savedProfiles").child(uid)
        return userProfileRef
    }
}
