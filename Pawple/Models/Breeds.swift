//
//  Breeds.swift
//  Pawple
//
//  Created by 22ysabelc on 11/29/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import Foundation

class Breeds: NSObject, Decodable {
    var breeds: [Name?]
}

class Name: Decodable {
    var name: String
}
