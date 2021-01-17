//
//  SpeciesFilter.swift
//  Pawple
//
//  Created by Hitesh Arora on 1/17/21.
//  Copyright © 2021 Ysabel Chen. All rights reserved.
//

import UIKit

enum Species {
    case dog
    case cat
    case none
}

class SpeciesFilter: NSObject {
    var arbitaryNumber: Int = 9999
    var searchFilter = [(section: String, data: [String], selected: Int)]()
    var selectedSpecies: Species = .none

    func returnSpecies() -> [(section: String, data: [String], selected: Int)] {
        switch selectedSpecies {
            case .cat:
                 return catFilter()
            case .dog:
                 return dogFilter()
            case .none:
                return [(section: "Species", data: ["Dog", "Cat"], selected: arbitaryNumber)]
        }
    }

    func catFilter() -> [(section: String, data: [String], selected: Int)] {
        return [(section: "Species", data: ["Dog", "Cat"], selected: 1),
                (section: "Breed", data: ["Any", "🔍 Search"], selected: 0),
                (section: "Age", data: ["Any", "Kitten", "Young", "Adult", "Senior"], selected: 0),
                (section: "Gender", data: ["Any", "Male", "Female"], selected: 0),
                (section: "Size", data: ["Any", "Small (0-6 lbs)", "Medium (7-11 lbs)", "Large (12-16 lbs)", "Extra Large (> 17 lbs)"], selected: 0),
                (section: "Color", data: ["Any", "🔍 Search"], selected: 0),
                (section: "Coat Length", data: ["Any", "Hairless", "Short", "Medium", "Long"], selected: 0),
                (section: "Care", data: ["Any", "House-trained", "Declawed", "Special needs"], selected: 0),
                (section: "Good with", data: ["Any", "Kids", "Dogs", "Other cats"], selected: 0),
                (section: "Location", data: ["Enter City, State, or ZIP", "Within 10 miles", "Within 25 miles", "Within 50 miles", "Within 100 miles", "Anywhere" ], selected: 0),
                (section: "Shelter/Rescue", data: ["Any", "🔍 Search"], selected: 0),
                (section: "Pet Name", data: ["Any", "🔍 Search"], selected: 0)]
    }

    func dogFilter() -> [(section: String, data: [String], selected: Int)] {
        return [(section: "Species", data: ["Dog", "Cat"], selected: 0),
                (section: "Breed", data: ["Any", "🔍 Search"], selected: 0),
                (section: "Age", data: ["Any", "Puppy", "Young", "Adult", "Senior"], selected: 0),
                (section: "Gender", data: ["Any", "Male", "Female"], selected: 0),
                (section: "Size", data: ["Any", "Small (0-25 lbs)", "Medium (26-60 lbs)", "Large (61-100 lbs)", "Extra Large (> 101 lbs)"], selected: 0),
                (section: "Color", data: ["Any", "🔍 Search"], selected: 0),
                (section: "Coat Length", data: ["Any", "Hairless", "Short", "Medium", "Long", "Wire", "Curly"], selected: 0),
                (section: "Care", data: ["Any", "House-trained", "Special needs"], selected: 0),
                (section: "Good with", data: ["Any", "Kids", "Dogs", "Cats"], selected: 0),
                (section: "Location", data: ["Enter City, State, or ZIP", "Within 10 miles", "Within 25 miles", "Within 50 miles", "Within 100 miles", "Anywhere" ], selected: 0),
                (section: "Shelter/Rescue", data: ["Any", "🔍 Search"], selected: 0),
                (section: "Pet Name", data: ["Any", "🔍 Search"], selected: 0)]
    }
}
