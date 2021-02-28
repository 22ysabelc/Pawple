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
    var arrayFilter = [(section: String, queryName: [String], data: [String], selected: [Int], multipleSelection: Bool)]()
    var selectedIndex: Int = 0
    var pagination: Pagination?
    var currentPage: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        if isTokenValid {
            switch getRouteName() {
                case .fetchListOfBreeds(let species):
                    APIServiceManager.shared.searchBreeds(species: SpeciesFilter.shared.selectedSpecies.description) { (breedNames) in
                        self.arrayList = breedNames.map {$0?.name}
                        self.tableView.reloadData()
                }
                case .fetchListOfColors(let species):
                    APIServiceManager.shared.fetchListOfColors(species: SpeciesFilter.shared.selectedSpecies.description) { (listOfcolors) in
                        if listOfcolors != nil {
                            self.arrayList = listOfcolors.map {$0.colors}!
                            self.tableView.reloadData()
                        }
                }
                case .fetchListOfOrganizations:
                    APIServiceManager.shared.fetchListOfOrganizations(pageNumber: self.currentPage) { (listOfOrgs, orgPagination) in
                        self.arrayList = listOfOrgs.map {$0?.name}
                        self.pagination = orgPagination
                        self.tableView.reloadData()
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
            SpeciesFilter.shared.addItemToList(array: &self.arrayFilter, name: selectedItem, index: self.selectedIndex)
            self.popViewController()
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
    
    // MARK: UICollectionViewDelegate
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.currentPage < self.pagination?.total_pages ?? 0 && (indexPath.item == self.arrayList.count-2) {
            self.currentPage += 1
            self.fetchListOfOrgs()
        }
    }
}

extension SearchTableViewController {
    func fetchListOfOrgs() {
        APIServiceManager.shared.fetchListOfOrganizations(pageNumber: self.currentPage) { (orgs, resultPagination) in
            self.arrayList.append(contentsOf: orgs.map {$0?.name})
            if let result = resultPagination {
                self.pagination = result
            }
            self.tableView.reloadData()
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
