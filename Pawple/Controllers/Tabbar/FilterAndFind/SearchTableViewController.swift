//
//  SearchTableViewController.swift
//  Pawple
//
//  Created by Hitesh Arora on 12/13/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    var arrayList = [String?]()
    var arraySelectedCells = [String]()
    var searchArrayList = [String?]()
    var arrayOrgs = [OrgDetails?]()
    var searchArrayOrgs = [OrgDetails?]()
    var isUserSearchingForOrg: Bool = false
    var searching = false
    var arrayFilter = [(section: String, queryName: [String], data: [String], displayName: [String], selected: [Int], multipleSelection: Bool)]()
    var selectedIndex: Int = 0
    var pagination: Pagination?
    var currentPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.keyboardDismissMode = .onDrag
        
        self.clearsSelectionOnViewWillAppear = false
        switch getRouteName() {
            case .fetchListOfBreeds( _):
                APIServiceManager.shared.searchBreeds(species: SpeciesFilter.shared.selectedSpecies.description) {
                    (breedNames) in
                    self.arrayList = breedNames.map {$0?.name}
                    self.tableView.reloadData()
            }
            case .fetchListOfColors( _):
                APIServiceManager.shared.fetchListOfColors(species: SpeciesFilter.shared.selectedSpecies.description) { (listOfcolors) in
                    if listOfcolors != nil {
                        self.arrayList = listOfcolors.map {$0.colors}!
                        self.tableView.reloadData()
                    }
            }
            case .fetchListOfOrganizations:
                self.isUserSearchingForOrg = true
                APIServiceManager.shared.fetchListOfOrganizations(pageNumber: self.currentPage) { (listOfOrgs, orgPagination) in
                    self.arrayOrgs = listOfOrgs
                    self.arrayList.append(contentsOf: listOfOrgs.map {$0?.name})
                    self.pagination = orgPagination
                    self.tableView.reloadData()
            }
            default:
                print("No route present to call")
        }

        self.arraySelectedCells = self.arrayFilter[self.selectedIndex].data

    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {

        print("Done button clicked")
        // Get selected cells and pop view controller
        let selected = tableView.indexPathsForSelectedRows
        print("selected rows: \(String(describing: selected))")
        self.popViewController()
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

        let cellTitle = searching ? self.searchArrayList[indexPath.row]: self.arrayList[indexPath.row]

        if arraySelectedCells.contains(cellTitle ?? "") {
            print("Name: \(String(describing: cellTitle))")
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.title.text = cellTitle

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedItem: String?
        var displayName: String?
        if isUserSearchingForOrg {
            if searching {
                selectedItem = self.searchArrayOrgs[indexPath.row]?.id
                displayName = self.searchArrayOrgs[indexPath.row]?.name
            } else {
                selectedItem = self.arrayOrgs[indexPath.row]?.id
                displayName = self.arrayOrgs[indexPath.row]?.name
            }
        } else {
            if searching {
                selectedItem = self.searchArrayList[indexPath.row]
                displayName = self.searchArrayList[indexPath.row]
            } else {
                selectedItem = self.arrayList[indexPath.row]
                displayName = self.arrayList[indexPath.row]
            }
        }

        // Close keyboard when you select cell
        self.searchBar.searchTextField.endEditing(true)
        if let selectedItem = selectedItem {
            if let tableviewCell = tableView.cellForRow(at: indexPath) {
                if tableviewCell.accessoryType == .checkmark {
                    tableviewCell.accessoryType = .none
                } else {
                    tableviewCell.accessoryType = .checkmark
                }
            }
            SpeciesFilter.shared.addItemToList(array: &self.arrayFilter, name: selectedItem, displayName: displayName ?? "", index: self.selectedIndex)
//            self.popViewController()
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
            self.fetchListOfOrgs(isUserScrolling: true)
        }
    }

}

extension SearchTableViewController {
    func fetchListOfOrgs(isUserScrolling: Bool = false) {

        APIServiceManager.shared.fetchListOfOrganizations(name: self.searchBar.searchTextField.text ?? "", pageNumber: self.currentPage) { (orgs, resultPagination) in

            if self.currentPage == 1 {
                self.arrayOrgs = orgs
                self.arrayList = orgs.map {$0?.name}
            } else {
                self.arrayOrgs.append(contentsOf: orgs)
                self.arrayList.append(contentsOf: orgs.map {$0?.name})
            }

            if self.searching {
                self.searchArrayList = self.arrayList
                self.searchArrayOrgs = orgs
            }
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
        if searchText == "" {
            self.searchBarCancelButtonClicked(searchBar)
            return
        }
        searchArrayList = arrayList.filter { $0!.lowercased().contains(searchText.lowercased()) }

        self.searchArrayOrgs = self.arrayOrgs.filter { ($0?.name?.lowercased().contains(searchText.lowercased()) ?? false)
        }
        self.searching = true

        if isUserSearchingForOrg {
            self.currentPage = 1
            self.fetchListOfOrgs()
        }
        tableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        searchBar.endEditing(true)
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
                    return .fetchListOfOrganizations("", 1)
                default:
                    return .fetchListOfBreeds("Dog")
            }
        }
        return .fetchListOfOrganizations("", 1)
    }
}


extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
