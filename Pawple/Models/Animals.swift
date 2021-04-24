//
//  Animals.swift
//  Pawple
//
//  Created by 22ysabelc on 11/29/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import Foundation

class Animals: NSObject, Decodable {
    var animals: [AnimalDetails?]
    var pagination: Pagination?
}

class Animal: NSObject, Decodable {
    var animal: AnimalDetails?
}

class Pagination: NSObject, Decodable {
    var count_per_page: Int
    var total_count: Int
    var current_page: Int
    var total_pages: Int
}

class AnimalDetails: NSObject, Decodable {
    var id: Int64 = 0
    var organization_id: String?
    var name: String?
    var type: String?
    var breeds: AnimalBreeds?
    var organization: Organization?
    var gender: String?
    var size: String?
    var coat: String?
    var colors: Colors?
    var age: String?
    var photos: [AnimalPhotos?] = []
    var status: String?
    var contact: ContactInfo?
    var desc: String?

    enum CodingKeys: String, CodingKey {

        case id
        case organization_id
        case name
        case type
        case breeds
        case organization
        case gender
        case size
        case coat
        case colors
        case age
        case photos
        case status
        case contact
        case desc = "description"
    }
}

class ContactInfo: NSObject, Decodable {
    var email: String?
    var phone: String?
    var address: OrgAddress?
}

class AnimalBreeds: NSObject, Decodable {
    var primary: String?
    var secondary: String?
    var mixed: Bool?
    var unknown: Bool?
}

class AnimalPhotos: NSObject, Decodable {
    var small: String?
    var medium: String?
    var large: String?
    var full: String?
}

class Organization: NSObject, Decodable {
    var organizations: [OrgDetails?]
    var pagination: Pagination?
}

class Org: NSObject, Decodable {
    var organization: OrgDetails?
}

class OrgDetails: NSObject, Decodable {
    var email: String?
    var name: String?
    var phone: String?
    var address: OrgAddress?
    var id: String?
}

class OrgAddress: NSObject, Decodable {
    var address1: String?
    var address2: String?
    var city: String?
    var state: String?
    var postcode: String?
    var country: String?
}

class TypeOfSpecies: NSObject, Decodable {
    var type: SpeciesProperties?
}

class SpeciesProperties: NSObject, Decodable {
    var name: String?
    var coats: [String]
    var colors: [String]
    var genders: [String]
}
class Colors: NSObject, Decodable {
    var primary: String?
    var secondary: String?
    var tertiary: String?
}
