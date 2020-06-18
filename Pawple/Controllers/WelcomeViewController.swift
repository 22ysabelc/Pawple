//
//  ViewController.swift
//  Pawple
//
//  Created by 22ysabelc on 4/22/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {
        
    @IBOutlet weak var welcomeText: CLTypingLabel!
    @IBOutlet weak var pawpleText: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        
        welcomeText.text = "    Welcome to"
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer) in
            print("timer: \(timer)")
            self.pawpleText.text = " Pawple "
        }
    }
}
