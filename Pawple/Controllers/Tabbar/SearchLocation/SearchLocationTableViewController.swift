//
//  SearchLocationTableViewController.swift
//  Pawple
//
//  Created by Hitesh Arora on 4/11/21.
//  Copyright © 2021 Ysabel Chen. All rights reserved.
//

import UIKit

class SearchLocationTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var arrayList = [Location?]()
    var searchArrayList = [Location?]()
    var searching: Bool = false
    var selectedIndex: Int = 0
    var arrayFilter = [(section: String, queryName: [String], data: [String], displayName: [String], selected: [Int], multipleSelection: Bool)]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        let locationModel = Location()
        self.arrayList = locationModel.loadJson() ?? []
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return self.searchArrayList.count
        }
        return self.arrayList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell

        if searching {
            if let location = self.searchArrayList[indexPath.row] {
                cell.title.text = self.getCityName(loc: location)
            }
        } else {
            if let location = self.arrayList[indexPath.row] {
                cell.title.text = self.getCityName(loc: location)
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedItem: String?

        if searching {
            if let location = self.searchArrayList[indexPath.row] {
                selectedItem = self.getCityName(loc: location)
            }
        } else {
            if let location = self.arrayList[indexPath.row] {
                selectedItem = self.getCityName(loc: location)
            }
        }
        // Close keyboard when you select cell
        self.searchBar.searchTextField.endEditing(true)
        if let selectedItem = selectedItem {
            SpeciesFilter.shared.addLocationToArray(array: &self.arrayFilter, name: selectedItem, index: self.selectedIndex)
            self.showMilesActionSheet()
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

    func getCityName(loc: Location) -> String{
        return "\(loc.city), \(loc.state_name)"
    }
}
// MARK: - SearchBar Delegates
extension SearchLocationTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.searchBarCancelButtonClicked(searchBar)
            return
        }
        searchArrayList = arrayList.filter({($0!.city.lowercased().contains(searchText.lowercased())) || ($0!.state_name.lowercased().contains(searchText.lowercased()))})
        self.searching = true
        tableView.reloadData()
    }


    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        searchBar.endEditing(true)
        tableView.reloadData()
    }
}

extension SearchLocationTableViewController: UIActionSheetDelegate {
    func showMilesActionSheet() {

         let actionSheet = UIAlertController(title: "Distance from this city", message: "", preferredStyle: .actionSheet )
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheet.addAction(cancelActionButton)

        let tenMilesActionButton = UIAlertAction(title: "10 miles", style: .default) { _ in
            self.addMilesToArrayFilter(selectedMiles: "Within 10 miles")
        }
        actionSheet.addAction(tenMilesActionButton)

        let twentyFiveMilesActionButton = UIAlertAction(title: "25 miles", style: .default) { _ in
            self.addMilesToArrayFilter(selectedMiles: "Within 25 miles")
        }
        actionSheet.addAction(twentyFiveMilesActionButton)
        let fiftyMilesActionButton = UIAlertAction(title: "50 miles", style: .default) { _ in
            self.addMilesToArrayFilter(selectedMiles: "Within 50 miles")
        }
        actionSheet.addAction(fiftyMilesActionButton)
        let hundredMilesActionButton = UIAlertAction(title: "100 miles", style: .default) { _ in
            self.addMilesToArrayFilter(selectedMiles: "Within 100 miles")
        }
        actionSheet.addAction(hundredMilesActionButton)
        self.present(actionSheet, animated: true, completion: nil)

    }

    func addMilesToArrayFilter(selectedMiles: String) {
        SpeciesFilter.shared.addLocationToArray(array: &self.arrayFilter, name: selectedMiles, index: self.selectedIndex, isMilesSelected: true)
         self.popViewController()
    }
}
