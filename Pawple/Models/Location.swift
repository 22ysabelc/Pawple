//
//  Location.swift
//  Pawple
//
//  Created by Hitesh Arora on 4/11/21.
//  Copyright © 2021 Ysabel Chen. All rights reserved.
//

import UIKit

struct ResponseData: Decodable {
    var location: [Location]
}

struct Location: Decodable {
    var city: String = ""
    var state_id: String = ""
    var state_name: String = ""
    var lat: Float = 0.0
    var lng: Float = 0.0

    func loadJson(filename fileName: String = "CityState") -> [Location]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                return jsonData.location
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}


