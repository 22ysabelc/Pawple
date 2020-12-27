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
    var isLoggedIn: Bool {
        if TokenManager.shared.fetchAccessToken() != nil {
            return true
        }
        return false
    }
    var arrayList = [Name?]()
    var searchArrayList = [Name?]()
    var searching = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        if isLoggedIn {
            APIServiceManager.shared.searchBreeds(species: "Dog") { (breedNames) in
                print("List of Breeds: \(breedNames)")
                self.arrayList.append(contentsOf: breedNames)
                self.tableView.reloadData()
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
            cell.title?.text = self.searchArrayList[indexPath.row]?.name
        } else {
            cell.title.text = arrayList[indexPath.row]?.name
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            let selectedItem = self.searchArrayList[indexPath.row]?.name
            print(selectedItem as Any)
        } else {
            let selectedItem = arrayList[indexPath.row]?.name
            print(selectedItem as Any)
        }
        // Close keyboard when you select cell
        self.searchBar.searchTextField.endEditing(true)
    }
}

// MARK: - SearchBar Delegates
extension SearchTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchArrayList = arrayList.filter { $0!.name.lowercased().prefix(searchText.count) == searchText.lowercased() }
        searching = true
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
}
