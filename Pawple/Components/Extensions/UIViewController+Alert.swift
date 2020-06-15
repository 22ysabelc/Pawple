//
//  UIViewController+Alert.swift
//  Pawple
//
//  Created by 22ysabelc on 6/12/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    func alert(title: String? = nil, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: false, completion: nil)
    }

    func showGeneralErrorAlert(message: String = "ErrorTryAgainLater") {
        self.alert(message: message)
    }
}
