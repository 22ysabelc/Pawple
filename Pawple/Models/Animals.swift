//
//  Animals.swift
//  Pawple
//
//  Created by 22ysabelc on 11/29/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import Foundation

class Animals: NSObject {
    var id: String?
    var type: String?
    var breed: String?
    var organization_id: String?
    var organization: Organization?
    var gender: String?
    var size: String?
    var coat: String?
    var color: String?
    var age: String?
    //add the other parameters
}

class Organization: NSObject, Decodable {
    var organizations: [OrgDetails?]
}

class OrgDetails: NSObject, Decodable {
    var email: String?
    var name: String?
    var phone: String?
    var address: OrgAddress?
}

class OrgAddress: NSObject, Decodable {
    var address1: String?
    var address2: String?
    var city: String?
    var state: String?
    var postcode: String?
    var country: String?
}

class Type: NSObject, Decodable {
    var type: TypeOfSpecies?
}
class TypeOfSpecies: NSObject, Decodable {
    var name: String?
    var coats: [String?]
    var colors: [String]
    var genders: [String?]
}
class Colors: NSObject, Decodable {
    var primary: String?
    var secondary: String?
    var tertiary: String?
}
