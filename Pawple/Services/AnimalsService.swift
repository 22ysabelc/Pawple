//
//  GetListOfBreedsService.swift
//  Pawple
//
//  Created by Hitesh Arora on 12/16/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit
import Alamofire

class AnimalsService: NSObject {

//    var token:

    public func getListOfBreeds(token: String, species: String = "dog") {

        let url = "https://api.petfinder.com/v2/types/\(species)/breeds/"
        let authToken = "Bearer \(token)"
        AF.request(url, method: .get, headers: ["Authorization": authToken]).responseDecodable(of: Breeds.self) {response in
            print("name of first \(species) breed: \(response.value?.breeds[0]?.name)")
        }
    }

    public func getListOfOrganizations(token: String) {

        let authToken = "Bearer \(token)"
        AF.request("https://api.petfinder.com/v2/organizations/", method: .get, headers: ["Authorization": authToken]).responseDecodable(of: Organization.self) {response in
            print("name of first organization: \(response.value?.organizations[0]?.name)")
        }
    }
    
    public func getListOfColors(token: String, species: String = "dog") {
        let authToken = "Bearer \(token)"
        AF.request("https://api.petfinder.com/v2/types/\(species)", method: .get, headers: ["Authorization": authToken]).responseDecodable(of: Colors.self) {response in
            print("first color: \(response.value)")
        }
    }
    
    // PetFinder doesn't have a list of locations, but we can use get list of animals and use the location??
    public func getListOfLocations(token: String) {
        
    }
    
    // PetFinder doesn't have a list of names for each species, but we can use get list of animals and use the name??
    public func getListOfNames(token: String, species: String = "dog") {
        
    }
}
