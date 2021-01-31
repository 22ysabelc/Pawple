//
//  FilterAndFindVC.swift
//  Pawple
//
//  Created by Hitesh Arora on 12/13/20.
//  Copyright © 2020 Ysabel Chen. All rights reserved.
//

import UIKit

class FilterAndFindVC: UIViewController {
    
    var isTokenNotExpired: Bool {
        let tokenExpirationTimestamp: String = TokenManager.shared.fetchTokenExpiration() ?? "0"
        if let doubleValue = Double(tokenExpirationTimestamp) {
            if doubleValue > Date.init().timeIntervalSince1970 {
                return true
            }
        }
        return false
    }
    
    var isTokenValid: Bool {
        if TokenManager.shared.fetchAccessToken() != nil && isTokenNotExpired {
            return true
        }
        return false
    }
    var routeNameSelected: PawpleRouter = .fetchListOfOrganizations
    var selectedSection: Int = 0
    var searchFilter = [(section: String, queryName: String, data: [String], selected: [Int], multipleSelection: Bool)]()
    let purpleColor = UIColor(red: 172/255.0, green: 111/255.0, blue: 234/255.0, alpha: 1.0)
    
    @IBOutlet weak var collectionViewFilter: UICollectionView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()
        SpeciesFilter.shared.selectedSpecies = .none
        self.searchFilter = SpeciesFilter.shared.returnSpecies()
        // Header View
        if let flowLayout = self.collectionViewFilter.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionHeadersPinToVisibleBounds = true
            flowLayout.sectionFootersPinToVisibleBounds = true
        }
        
        if !isTokenValid {
            APIServiceManager.shared.fetchAccessToken { (isSuccess) in
                if !isSuccess {
                    print("Error fetching Access Token")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchTableViewController" {
            if let objVC = segue.destination as? SearchTableViewController {
                objVC.selectedIndex = selectedSection
                objVC.arrayFilter = self.searchFilter
            }
        } else if segue.identifier == "goToResults" {
            if segue.destination is ResultsCollectionVC {
                SpeciesFilter.shared.createSearchQuery(array: self.searchFilter)
            }
        }
    }
}

extension FilterAndFindVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.searchFilter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchFilter[section].data.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        guard kind == UICollectionView.elementKindSectionHeader else {
            if let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FilterCollectionFooterView", for: indexPath) as? FilterCollectionFooterView {
                return footerView
            }
            return UICollectionReusableView()
        }
        if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FilterCollectionHeaderView", for: indexPath) as? FilterCollectionHeaderView {
            headerView.title.text = self.searchFilter[indexPath.section].section
            return headerView
        }
        return UICollectionReusableView()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ofType: FilterViewCell.self, for: indexPath)
        let data = self.searchFilter[indexPath.section].data[indexPath.item]
        cell.labelFilterName.text = data

        let isCellSelected =  self.searchFilter[indexPath.section].selected.contains(indexPath.item)

        if isCellSelected {
            cell.labelFilterName.textColor = .purple
            cell.layer.borderColor = UIColor.purple.cgColor
            cell.layer.borderWidth = 2.5
            
        } else {
            cell.labelFilterName.textColor = .darkGray
            cell.layer.borderColor = UIColor.darkGray.cgColor
            cell.layer.borderWidth = 1.5
        }
        
        cell.layer.cornerRadius = 8
        cell.tag = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // if item contains search text
        if self.searchFilter[indexPath.section].data[indexPath.item].contains("Search") {
            self.selectedSection = indexPath.section

            if self.searchFilter[indexPath.section].section == "Pet Name" {
                var inputTextField: UITextField?

                let alert = UIAlertController(title: nil, message: "Please Enter A \(SpeciesFilter.shared.selectedSpecies.description.capitalized) Name", preferredStyle: .alert)
                alert.addTextField { (textfield) in
                    inputTextField = textfield
                }
                alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (_) in
                    if (inputTextField?.text?.count)! > 0 {
                        SpeciesFilter.shared.addItemToList(array: &self.searchFilter, name: inputTextField!.text!.capitalized, index: indexPath.section)
                        self.collectionViewFilter.reloadSections(IndexSet(integer: indexPath.section))
                    }
                }))
                self.present(alert, animated: true)
            } else {
                self.performSegue(withIdentifier: "SearchTableViewController", sender: self)
            }
        } else {
            // Check for Species
            if indexPath.section == 0 {
                SpeciesFilter.shared.selectedSpecies = indexPath.item == 0 ? Species.dog : Species.cat
                self.searchFilter = SpeciesFilter.shared.returnSpecies()
                self.collectionViewFilter.reloadData()
            } else {
                if self.searchFilter[indexPath.section].multipleSelection == true {
                    var array = self.searchFilter[indexPath.section].selected

                    // If first item (Any) is selected, we will just select that item
                    if indexPath.item == 0 {
                        array = [indexPath.item]
                    } else if array.contains(indexPath.item) {
                        if let index = array.firstIndex(of: indexPath.item) {
                            array.remove(at: index)
                        }
                        array = array.count == 0 ? [0] : array
                    } else if !array.contains(indexPath.item) {
                        if let index = array.firstIndex(of: 0) {
                            array.remove(at: index)
                        }
                        array.append(indexPath.item)
                    }
                    self.searchFilter[indexPath.section].selected = array
                } else {
                    self.searchFilter[indexPath.section].selected = [indexPath.item]
                }
                self.collectionViewFilter.reloadSections(IndexSet(integer: indexPath.section))
            }
        }
    }
}

extension FilterAndFindVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        let arrayFilterCount = self.searchFilter.count
        if arrayFilterCount > 1 && section == arrayFilterCount - 1 {
            return CGSize(width: collectionView.bounds.size.width, height: 70)
        }
        return CGSize(width: collectionView.bounds.size.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        let totalCellWidth = Int(collectionView.layer.frame.size.width) / 3 * collectionView.numberOfItems(inSection: 0)
        let totalSpacingWidth = (collectionView.numberOfItems(inSection: section) - 1)
        
        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        //        let rightInset = leftInset
        
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
}


extension UIColor {
    static let selectedbackgroundFilterColor = UIColor(red: 121/255, green: 22/255, blue: 211/255, alpha: 1.0)
    static let deSelectedFilterTextColor = UIColor(red: 121/255, green: 22/255, blue: 211/255, alpha: 1.0)
}

extension CGColor {
    static let selectedBorderFilterColor = UIColor(red: 121/255, green: 22/255, blue: 211/255, alpha: 1.0).cgColor
}
