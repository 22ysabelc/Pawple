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
