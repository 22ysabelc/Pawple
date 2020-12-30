//
//  SearchTableViewController.swift
//  Pawple
//
//  Created by Hitesh Arora on 12/13/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var isTokenValid: Bool {
        if TokenManager.shared.fetchAccessToken() != nil {
            return true
        }
        return false
    }

    var arrayList = [String?]()
    var searchArrayList = [String?]()
    var searching = false
    var arrayFilter = [(section: String, data: [String], selected: Int)]()
    var selectedIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        if isTokenValid {
            switch getRouteName() {
                case .fetchListOfBreeds(let species):
                    APIServiceManager.shared.searchBreeds(species: species) { (breedNames) in
                        self.arrayList = breedNames.map {$0?.name}
                        self.tableView.reloadData()
                    }
                case .fetchListOfColors(let species):
                    APIServiceManager.shared.fetchListOfColors(species: species) { (listOfcolors) in
                        self.arrayList = listOfcolors.map {$0.colors} as! [String?]
                        self.tableView.reloadData()
                }
                case .fetchListOfOrganizations:
                    APIServiceManager.shared.fetchListOfOrganizations { (listOfOrgs) in
                        print("First organization name: \(listOfOrgs[0]?.name)")
                    }
                case .fetchListOfNames(_):
                    print("Nor route present to call")
                default:
                    print("Nor route present to call")
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchArrayList.count
        } else {
            return arrayList.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell

        if searching {
            cell.title?.text = self.searchArrayList[indexPath.row]
        } else {
            cell.title.text = arrayList[indexPath.row]
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedItem: String?
        if searching {
            selectedItem = self.searchArrayList[indexPath.row]
        } else {
            selectedItem = arrayList[indexPath.row]

        }
        // Close keyboard when you select cell
        self.searchBar.searchTextField.endEditing(true)

        if let selectedItem = selectedItem {
            self.addItemToList(itemName: selectedItem)
            self.popViewController()
        }
    }

    func addItemToList(itemName: String) {
        if self.arrayList.count >= self.selectedIndex {
            var dataArray = self.arrayFilter[self.selectedIndex].data
            if dataArray.count > 2 {
                dataArray.remove(at: 1)
            }
            dataArray.insert(itemName, at: 1)
            self.arrayFilter[self.selectedIndex].data = dataArray
            self.arrayFilter[self.selectedIndex].selected = 1
        }
    }

    func popViewController() {
        if let count: Int = self.navigationController?.viewControllers.count {
            if count >= 2 {
                if let objFilterVC = self.navigationController?.viewControllers[count-2] as? FilterAndFindVC {
                    objFilterVC.searchFilter = arrayFilter
                    objFilterVC.collectionViewFilter.reloadData()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

// MARK: - SearchBar Delegates
extension SearchTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchArrayList = arrayList.filter { $0!.lowercased().prefix(searchText.count) == searchText.lowercased() }
        searching = true
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }

    func getRouteName() -> PawpleRouter {
        if self.arrayFilter.count >= self.selectedIndex {
            let section = self.arrayFilter[self.selectedIndex].section
            switch section {
                case "Breed":
                    return .fetchListOfBreeds("Dog")
                case "Color":
                    return .fetchListOfColors("Dog")
                case "Shelter/Rescue":
                    return .fetchListOfOrganizations
                default:
                    return .fetchListOfBreeds("Dog")
            }
        }
        return .fetchListOfOrganizations
    }
}
