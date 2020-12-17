//
//  PetFinder.swift
//  Pawple
//
//  Created by Hitesh Arora on 12/15/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit

class PetFinder: NSObject, Decodable {

    public static let shared = PetFinder()

    var access_token: String = ""
    var expires_in: Double = 0.0
//    var tokenExpiresAt: TimeInterval?

//    internal var accessToken: String? {
//        //check if token exist
//        // check if token is valid and then return it.
//        let now = Date().timeIntervalSinceNow
////        if self.tokenExpiresAt > now {
////            print("Token is still valid")
////        }
//    }
//
//    enum CodingKeys : String, CodingKey {
//        case accessToken = "access_token"
//    }
}
//extension PetFinder {
//
    func processFields() {
//        print("Expires at: %@", Date().addingTimeInterval(TimeInterval(self.expires_in)))
//        self.tokenExpiresAt = Date.init(timeIntervalSinceNow: TimeInterval(self.expires_in)).timeIntervalSinceReferenceDate
//
//        debugPrint("tokenExpiresAt: \(String(describing: self.tokenExpiresAt))")
    }
//}
