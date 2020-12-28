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
    var searchFilter = [(section: String, data: [String?], selected: Int?)]()
    let purpleColor = UIColor(red: 172/255.0, green: 111/255.0, blue: 234/255.0, alpha: 1.0)

    @IBOutlet weak var collectionViewFilter: UICollectionView!

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchFilter = [(section: "Species", data: ["Dog", "Cat"], selected: 0),
                             (section: "Breed", data: ["Any", "🔍 Search"], selected: 0),
                             (section: "Age", data: ["Any", "Puppy", "Young", "Adult", "Senior"], selected: 4),
                             (section: "Gender", data: ["Any", "Male", "Female"], selected: 0),
                             (section: "Size", data: ["Any", "Small (0-25 lbs)", "Medium (26-60 lbs)", "Large (61-100 lbs)", "Extra Large (> 101 lbs)"], selected: 0),
                             (section: "Color", data: ["Any", "🔍 Search"], selected: 0),
                             (section: "Coat Length", data: ["Any", "Hairless", "Short", "Medium", "Long", "Wire", "Curly"], selected: 0),
                             (section: "Care", data: ["Any", "House-trained", "Special needs"], selected: 0),
                             (section: "Good with", data: ["Any", "Kids", "Dogs", "Cats"], selected: 0),
                             (section: "Location", data: ["Enter City, State, or ZIP", "Within 10 miles", "Within 25 miles", "Within 50 miles", "Within 100 miles", "Anywhere" ], selected: 0),
                             (section: "Shelter/Rescue", data: ["Any", "🔍 Search"], selected: 0),
                             (section: "Pet Name", data: ["Any", "🔍 Search"], selected: 0)]
// Header View
        if let flowLayout = self.collectionViewFilter.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionHeadersPinToVisibleBounds = true
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
                objVC.routeName = self.routeNameSelected
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
        let isCellSelected = self.searchFilter[indexPath.section].selected

        if(indexPath.item == isCellSelected) {
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
        //        let cell = collectionView.cellForItem(at: indexPath) as! FilterViewCell
        if let _ =  self.searchFilter[indexPath.section].data[indexPath.item]?.contains("Search") {
            let section = self.searchFilter[indexPath.section].section
            switch section {
                case "Breed":
                    routeNameSelected = .fetchListOfBreeds("Dog")
                default:
                    routeNameSelected = .fetchListOfBreeds("Dog")
            }

            self.performSegue(withIdentifier: "SearchTableViewController", sender: self)
        }
        else {
            self.searchFilter[indexPath.section].selected = indexPath.row
            self.collectionViewFilter.reloadSections(IndexSet(integer: indexPath.section))
        }
    }
}

extension FilterAndFindVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: collectionView.bounds.size.width, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {


        let totalCellWidth = Int(collectionView.layer.frame.size.width) / 3 * collectionView.numberOfItems(inSection: 0)
        let totalSpacingWidth = (collectionView.numberOfItems(inSection: section) - 1)

        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)



        let collectionViewWidth = collectionView.bounds.size.width

        //Where elements_count is the count of all your items in that
        //Collection view...
        let cellCount = CGFloat(self.searchFilter[section].data.count)

        //If the cell count is zero, there is no point in calculating anything.
        if cellCount > 0 {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing

            //20.00 was just extra spacing I wanted to add to my cell.
            let totalCellWidth = cellWidth*cellCount + 0.00 * (cellCount-1)
            let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right

            if (totalCellWidth < contentWidth) {
                //If the number of cells that exists take up less room than the
                //collection view width... then there is an actual point to centering them.

                //Calculate the right amount of padding to center the cells.
                let padding = (contentWidth - totalCellWidth) / 2.0
                return UIEdgeInsets(top: 5, left: padding, bottom: 5, right: padding)
            } else {
                //Pretty much if the number of cells that exist take up
                //more room than the actual collectionView width, there is no
                // point in trying to center them. So we leave the default behavior.
                return UIEdgeInsets(top: 5, left: 40, bottom: 5, right: 40)
            }
        }
        return UIEdgeInsets.zero
    }
}


extension UIColor {
    static let selectedbackgroundFilterColor = UIColor(red: 121/255, green: 22/255, blue: 211/255, alpha: 1.0)
    static let deSelectedFilterTextColor = UIColor(red: 121/255, green: 22/255, blue: 211/255, alpha: 1.0)
}

extension CGColor {
    static let selectedBorderFilterColor = UIColor(red: 121/255, green: 22/255, blue: 211/255, alpha: 1.0).cgColor
}
