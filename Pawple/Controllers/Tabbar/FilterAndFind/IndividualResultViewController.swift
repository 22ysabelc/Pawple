//
//  IndividualResultViewController.swift
//  Pawple
//
//  Created by 22ysabelc on 2/6/21.
//  Copyright © 2021 Ysabel Chen. All rights reserved.
//

import UIKit

class IndividualResultViewController: UIViewController {

    @IBOutlet weak var petName: UILabel! {
        didSet {
            self.petName.layer.cornerRadius = self.petName.frame.height/6
            self.petName.clipsToBounds = true
        }
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
