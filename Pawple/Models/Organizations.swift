//
//  Organizations.swift
//  Pawple
//
//  Created by 22ysabelc on 12/5/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import Foundation

class Organizations: NSObject {
    var email: String?
    var phone: String?
    var address: OrganizationAddress?
}

class OrganizationAddress: NSObject {
    var address1: String?
    var address2: String?
    var city: String?
    var state: String?
    var postcode: String?
    var country: String?
}
