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
    var searchFilter = [(section: String, data: [String], selected: Int)]()
    var selectedSpecies: Species = .none

    func returnSpecies() -> [(section: String, queryName: String, data: [String], selected: Int)] {
        switch selectedSpecies {
            case .cat:
                 return catFilter()
            case .dog:
                 return dogFilter()
            case .none:
                return [(section: "Species", queryName: "type", data: ["Dog", "Cat"], selected: arbitaryNumber)]
        }
    }

    func catFilter() -> [(section: String, queryName: String, data: [String], selected: Int)] {
        return [(section: "Species", queryName: "type", data: ["Dog", "Cat"], selected: 1),
                (section: "Breed", queryName: "type", data: ["Any", "🔍 Search"], selected: 0),
                (section: "Age", queryName: "age", data: ["Any", "Kitten", "Young", "Adult", "Senior"], selected: 0),
                (section: "Gender", queryName: "gender", data: ["Any", "Male", "Female"], selected: 0),
                (section: "Size", queryName: "size", data: ["Any", "Small (0-6 lbs)", "Medium (7-11 lbs)", "Large (12-16 lbs)", "Extra Large (> 17 lbs)"], selected: 0),
                (section: "Color", queryName: "type", data: ["Any", "🔍 Search"], selected: 0),
                (section: "Coat Length", queryName: "coat", data: ["Any", "Hairless", "Short", "Medium", "Long"], selected: 0),
                (section: "Care", queryName: "special_needs", data: ["Any", "House-trained", "Declawed", "Special needs"], selected: 0),
                (section: "Good with", queryName: "type", data: ["All (Kids, Dogs, Cats)", "None", "Kids", "Dogs", "Cats"], selected: 0),
                (section: "Location", queryName: "location", data: ["🔍 City, State, or ZIP", "Within 10 miles", "Within 25 miles", "Within 50 miles", "Within 100 miles", "Anywhere" ], selected: 5),
                (section: "Shelter/Rescue", queryName: "organization", data: ["Any", "🔍 Search"], selected: 0),
                (section: "Pet Name", queryName: "name", data: ["Any", "🔍 Search"], selected: 0),
                (section: "Days The Pet Has Been Available", queryName: "name", data: ["Any", "1", "7", "14", "30+"], selected: 0)]
    }

    func dogFilter() -> [(section: String, queryName: String, data: [String], selected: Int)] {
        return [(section: "Species", queryName: "type", data: ["Dog", "Cat"], selected: 0),
                (section: "Breed", queryName: "Breed", data: ["Any", "🔍 Search"], selected: 0),
                (section: "Age", queryName: "Age", data: ["Any", "Puppy", "Young", "Adult", "Senior"], selected: 0),
                (section: "Gender", queryName: "Gender", data: ["Any", "Male", "Female"], selected: 0),
                (section: "Size", queryName: "Size", data: ["Any", "Small (0-25 lbs)", "Medium (26-60 lbs)", "Large (61-100 lbs)", "Extra Large (> 101 lbs)"], selected: 0),
                (section: "Color", queryName: "Color", data: ["Any", "🔍 Search"], selected: 0),
                (section: "Coat Length", queryName: "coat", data: ["Any", "Hairless", "Short", "Medium", "Long", "Wire", "Curly"], selected: 0),
                (section: "Care", queryName: "Care", data: ["Any", "House-trained", "Special needs"], selected: 0),
                (section: "Good with", queryName: "type", data: ["All (Kids, Dogs, Cats)", "None", "Kids", "Dogs", "Cats"], selected: 0),
                (section: "Location", queryName: "Location", data: ["🔍 City, State, or ZIP", "Within 10 miles", "Within 25 miles", "Within 50 miles", "Within 100 miles", "Anywhere" ], selected: 5),
                (section: "Shelter/Rescue", queryName: "organization", data: ["Any", "🔍 Search"], selected: 0),
                (section: "Pet Name", queryName: "name", data: ["Any", "🔍 Search"], selected: 0),
                (section: "Days The Pet Has Been Available", queryName: "name", data: ["Any", "1", "7", "14", "30+"], selected: 0)]
    }

    func addItemToList(array: inout [(section: String, queryName: String, data: [String], selected: Int)], name: String, index: Int) {
        if array.count >= index {
            var dataArray = array[index].data
            if dataArray.count > 2 {
                dataArray.remove(at: 1)
            }
            dataArray.insert(name, at: 1)
            array[index].data = dataArray
            array[index].selected = 1
        }
    }

    func createSearchQuery(array: [(section: String, queryName: String, data: [String], selected: Int)]) -> String {

        var queryString = ""
        for index in array {
            queryString.append("\(index.queryName)=\(index.data[index.selected]),")
        }
        queryString.append("status=adoptable")
        print("++++++++++++++++\(queryString)")
        return queryString
    }
}
