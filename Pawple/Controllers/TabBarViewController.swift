//
//  TabBarViewController.swift
//  Pawple
//
//  Created by 22ysabelc on 4/28/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.hidesBackButton = true
        navigationController?.setNavigationBarHidden(true, animated: false)
//        getLoginState()
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
