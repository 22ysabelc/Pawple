//
//  Animals.swift
//  Pawple
//
//  Created by 22ysabelc on 11/29/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import Foundation

class Animals: NSObject {
    // status should always be "adoptable"
    var id: String?
    var species: String?
    var breed: Breed?
    var organization_id: String?
    var organization: Organization?
    var organization_animal_id: String?
    var gender: String?
    var size: String?
    var coat: String?
    var color: Color?
    var age: String?
    var attributes: Attributes?
    var environment: Environment?
    var name: String?
    var animalDescription: String?
    var primaryPhoto_cropped: Photos?
    // add multiple pictures and videos later
}

class Breed: NSObject {
    var primary: String?
    var secondary: String?
    var mixed: Bool?
    var unknown: Bool?
}

class Organization: NSObject {
    var email: String?
    var phone: String?
    var address: OrgAddress?
}

class OrgAddress: NSObject {
    var address1: String?
    var address2: String?
    var city: String?
    var state: String?
    var postcode: String?
    var country: String?
}

class Color: NSObject {
    var primary: String?
    var secondary: String?
    var tertiary: String?
}

class Attributes: NSObject {
    var spayed_neutered: Bool?
    var houseTrained: Bool?
    var declawed: Bool?
    var specialNeeds: Bool?
    var shotsCurrent: Bool?
}

class Environment: NSObject {
    var children: Bool?
    var dogs: Bool?
    var cats: Bool?
}

class Photos: NSObject {
    var small: String?
    var medium: String?
    var large: String?
    var full: String?
}
