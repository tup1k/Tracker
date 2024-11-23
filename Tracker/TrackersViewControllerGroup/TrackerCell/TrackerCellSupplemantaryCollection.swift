//
//  TrackerCellSupplemantaryCollection.swift
//  Tracker
//
//  Created by Олег Кор on 11.11.2024.
//

import UIKit

final class TrackerCellSupplemantaryCollection: NSObject, UICollectionViewDataSource {
    let count: Int
    
    init(count: Int) {
        self.count = count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as? TrackerCellViewController else {return UICollectionViewCell()}
        cell.prepareForReuse()
        return cell
    }
}
