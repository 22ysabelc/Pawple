//
//  GetOAuthTokenService.swift
//  Pawple
//
//  Created by Hitesh Arora on 12/15/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit
import Alamofire

class GetOAuthTokenService: NSObject {

    public func getOAuthToken() -> String {
        var parameters: Parameters = [String: Any]()
        parameters["grant_type"] = "client_credentials"
        parameters["client_id"] = "8FwXb2xm6KosmlowWkPKuQHrZm9zkhxixhVESe1QhMZEBQIbHW"
        parameters["client_secret"] = "kIGdjXKoBjPGBsOhGoMheYQe3tUbVPxG2n65hRoy"

        AF.request("https://api.petfinder.com/v2/oauth2/token", method: .post, parameters: parameters).responseDecodable(of: PetFinder.self) {response in
            if let petFinder = response.value as? PetFinder {
                print("accessToken: \(petFinder.access_token)")
            }
        }
        return ""
    }
}
