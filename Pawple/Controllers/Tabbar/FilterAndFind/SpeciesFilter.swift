//
//  SpeciesFilter.swift
//  Pawple
//
//  Created by Hitesh Arora on 1/17/21.
//  Copyright © 2021 Ysabel Chen. All rights reserved.
//

//Reference: https://www.petfinder.com/developers/v2/docs/#get-animals

import UIKit

enum Species: String {
    case dog
    case cat
    case none
    var description: String {
        return self.rawValue
    }
}

class SpeciesFilter: NSObject {

    static let shared = SpeciesFilter()
    var arbitaryNumber: Int = 9999
    var searchFilter = [(section: String, queryName: [String], data: [String], selected: [Int], multipleSelection: Bool)]()
    var selectedSpecies: Species = .none

    func returnSpecies() -> [(section: String, queryName: [String], data: [String], selected: [Int], multipleSelection: Bool)] {
        switch selectedSpecies {
            case .cat:
                 return catFilter()
            case .dog:
                 return dogFilter()
            case .none:
                return [(section: "Species", queryName: ["type"], data: ["Dog", "Cat"], selected: [arbitaryNumber], multipleSelection: false)]
        }
    }

    func catFilter() -> [(section: String, queryName: [String], data: [String], selected: [Int], multipleSelection: Bool)] {
        return [(section: "Species", queryName: ["type"], data: ["Dog", "Cat"], selected: [1], multipleSelection: false),
                (section: "Breed", queryName: ["breed"], data: ["Any", "🔍 Search"], selected: [0], multipleSelection: true),
                (section: "Age", queryName: ["age"], data: ["Any", "Kitten", "Young", "Adult", "Senior"], selected: [0], multipleSelection: true),
                (section: "Gender", queryName: ["gender"], data: ["Any", "Male", "Female"], selected: [0], multipleSelection: true),
                (section: "Size", queryName: ["size"], data: ["Any", "Small (0-6 lbs)", "Medium (7-11 lbs)", "Large (12-16 lbs)", "Extra Large (> 17 lbs)"], selected: [0], multipleSelection: true),
                (section: "Color", queryName: ["color"], data: ["Any", "🔍 Search"], selected: [0], multipleSelection: true),
                (section: "Coat Length", queryName: ["coat"], data: ["Any", "Hairless", "Short", "Medium", "Long"], selected: [0], multipleSelection: true),
                (section: "Care", queryName: ["house_trained", "declawed", "special_needs"], data: ["Any", "House-trained", "Declawed", "Special needs"], selected: [0], multipleSelection: true),
                (section: "Good with", queryName: ["good_with_children", "good_with_dogs", "good_with_cats"], data: ["Any", "Kids", "Dogs", "Other cats"], selected: [0], multipleSelection: true),
                (section: "Location", queryName: ["location"], data: ["Anywhere", "🔍 City, State, or ZIP", "Within 10 miles", "Within 25 miles", "Within 50 miles", "Within 100 miles"], selected: [0], multipleSelection: false),
                (section: "Shelter/Rescue", queryName: ["organization"], data: ["Any", "🔍 Search"], selected: [0], multipleSelection: true),
                (section: "Pet Name", queryName: ["name"], data: ["Any", "🔍 Search"], selected: [0], multipleSelection: false),
                (section: "Days The Pet Has Been Available", queryName: ["name"], data: ["Any", "1", "7", "14", "30+"], selected: [0], multipleSelection: false)]
    }

    func dogFilter() -> [(section: String, queryName: [String], data: [String], selected: [Int], multipleSelection: Bool)] {
        return [(section: "Species", queryName: ["type"], data: ["Dog", "Cat"], selected: [0], multipleSelection: false),
                (section: "Breed", queryName: ["breed"], data: ["Any", "🔍 Search"], selected: [0], multipleSelection: true),
                (section: "Age", queryName: ["age"], data: ["Any", "Puppy", "Young", "Adult", "Senior"], selected: [0], multipleSelection: true),
                (section: "Gender", queryName: ["gender"], data: ["Any", "Male", "Female"], selected: [0], multipleSelection: true),
                (section: "Size", queryName: ["size"], data: ["Any", "Small (0-25 lbs)", "Medium (26-60 lbs)", "Large (61-100 lbs)", "Extra Large (> 101 lbs)"], selected: [0], multipleSelection: true),
                (section: "Color", queryName: ["color"], data: ["Any", "🔍 Search"], selected: [0], multipleSelection: true),
                (section: "Coat Length", queryName: ["coat"], data: ["Any", "Hairless", "Short", "Medium", "Long", "Wire", "Curly"], selected: [0], multipleSelection: true),
                (section: "Care", queryName: ["house_trained", "special_needs"], data: ["Any", "House-trained", "Special needs"], selected: [0], multipleSelection: true),
                (section: "Good with", queryName: ["good_with_children", "good_with_dogs", "good_with_cats"], data: ["Any", "Kids", "Other dogs", "Cats"], selected: [0], multipleSelection: true),
                (section: "Location", queryName: ["location"], data: ["Anywhere", "🔍 City, State, or ZIP", "Within 10 miles", "Within 25 miles", "Within 50 miles", "Within 100 miles"], selected: [0], multipleSelection: false),
                (section: "Shelter/Rescue", queryName: ["organization"], data: ["Any", "🔍 Search"], selected: [0], multipleSelection: true),
                (section: "Pet Name", queryName: ["name"], data: ["Any", "🔍 Search"], selected: [0], multipleSelection: false),
                (section: "Days The Pet Has Been Available", queryName: ["name"], data: ["Any", "1", "7", "14", "30+"], selected: [0], multipleSelection: false)]
    }

    func addItemToList(array: inout [(section: String, queryName: [String], data: [String], selected: [Int], multipleSelection: Bool)], name: String, index: Int) {
        if array.count >= index {
            var dataArray = array[index].data
            if dataArray.count > 2 {
                dataArray.remove(at: 1)
            }
            dataArray.insert(name, at: 1)
            array[index].data = dataArray
            array[index].selected = [1]
        }
    }

    func createSearchQuery(array: [(section: String, queryName: [String], data: [String], selected: [Int], multipleSelection: Bool)]) -> String {

        var queryString = ""
        for index in array {

            if index.queryName.count > 1 && index.queryName.count >= index.selected.count {
                for item in index.selected {
                    if item == 0 {
                        for query in index.queryName {
                            queryString.append("\(query)=true,")
                        }
                    } else {
                        queryString.append("\(index.queryName[item-1])=true,")
                    }
                }
            } else {
                queryString.append("\(index.queryName.first!)=\(index.data[index.selected.first ?? 0]),")
            }
        }
        queryString.append("status=adoptable")
        print("++++++++++++++++\(queryString)")
        return queryString
    }
}
