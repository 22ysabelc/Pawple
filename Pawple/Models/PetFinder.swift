//
//  PetFinder.swift
//  Pawple
//
//  Created by Hitesh Arora on 12/15/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit

class PetFinder: NSObject, Decodable {

//    public static let shared = PetFinder()

//    var access_token: String?
    var expires_in: Double?
    var tokenExpiresAt: Date?

    internal var access_token: String? {
        // check if token exist
        // check if token is valid and then return it.
//        if let tokenValidity = self.tokenExpiresAt, tokenValidity > Date() {
//            print("Token is still valid")
//            return "token"
//        } else {
            // request for Token
//            let objAuthService = GetOAuthTokenService()
//            objAuthService.getOAuthToken(success: { (token) in
//                print("token:------> \(token)")
//            }) { (failuree) in
//                print("Token fetch failed: \(failuree)")
//            }
//        }

        return access_token
    }
}
extension PetFinder {

    func processFields() {
        print("Expires at: %@", Date().addingTimeInterval(TimeInterval(self.expires_in ?? 0)))
        if let tokenExpiresIn = self.expires_in {
            self.tokenExpiresAt = Date.init(timeIntervalSinceNow: TimeInterval(tokenExpiresIn ))
            debugPrint("tokenExpiresAt: \(String(describing: self.tokenExpiresAt))")
        }
    }
}
