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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
