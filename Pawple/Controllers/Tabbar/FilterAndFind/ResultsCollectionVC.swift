//
//  ResultsCollectionViewController.swift
//  Pawple
//
//  Created by 22ysabelc on 1/2/21.
//  Copyright © 2021 Ysabel Chen. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ResultsCollectionVC: UICollectionViewController {
    
    var arrayResults: [AnimalDetails?] = []
    var pagination: Pagination?
    var currentPage: Int = 1
    let searchQuery: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchAnimals()
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return arrayResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ofType: ResultsCollectionViewCell.self, for: indexPath)
        cell.petName.text = arrayResults[indexPath.item]?.name
        guard let arrayPhotos = arrayResults[indexPath.item]?.photos
            else {
                return cell
        }
        if arrayPhotos.count > 0 {
            cell.petImage.sd_setImage(with: URL(string: (arrayPhotos[0]?.medium)!))
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if self.currentPage < self.pagination?.total_pages ?? 0 && (indexPath.item == self.arrayResults.count-2) {
            self.currentPage += 1
            self.fetchAnimals()
        }
    }
}

extension ResultsCollectionVC {
    func fetchAnimals() {
        APIServiceManager.shared.fetchResults(pageNumber: self.currentPage) { (animals, resultPagination) in
            self.arrayResults.append(contentsOf: animals)
            if let result = resultPagination {
                self.pagination = result
            }
            self.collectionView.reloadData()
        }
    }
}
