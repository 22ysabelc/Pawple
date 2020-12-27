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

    public func getOAuthToken(success: @escaping (_ accessToken: String) -> Void, failure: @escaping (_ error: String) -> Void) {
        var parameters: Parameters = [String: Any]()
        parameters["grant_type"] = "client_credentials"
        parameters["client_id"] = "8FwXb2xm6KosmlowWkPKuQHrZm9zkhxixhVESe1QhMZEBQIbHW"
        parameters["client_secret"] = "kIGdjXKoBjPGBsOhGoMheYQe3tUbVPxG2n65hRoy"

//        AF.request("https://api.petfinder.com/v2/oauth2/token", method: .post, parameters: parameters).responseJSON { (response) in
//            print("JSON: \(response.value)")
//            success("tokene")
//        }
//        success("token")
        /**
         AF.request("https://api.petfinder.com/v2/oauth2/token", method: .post, parameters: parameters).responseDecodable(of: PetFinder.self) {response in
         print("response result: \(response.result)")
         if let petFinder = response.value {
         print("accessToken: \(String(describing: petFinder.access_token))")
         print("accessToken from shared class: \(String(describing: PetFinder.shared.access_token))")

         // get list of breeds

         //                let objAnimalsService = AnimalsService()

         //                print(objAnimalsService.getListOfBreeds(token: petFinder.access_token, species: "cat"))
         //
         //                print(objAnimalsService.getListOfOrganizations(token: petFinder.access_token))
         }
         }
         */
    }
}
