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
    
//    // Размеры для коллекции:
//let size = CGRect(origin: CGPoint(x: 0, y: 0),
//                  size: CGSize(width: 400, height: 600))
//// Указываем, какой Layout хотим использовать:
//let layout = UICollectionViewFlowLayout()
//
//let helper = TrackerCellSupplemantaryCollection(count: 31)
//let collection = UICollectionView(frame: size, collectionViewLayout: layout)
//    // Регистрируем ячейку в коллекции.
//    // Регистрируя ячейку, мы сообщаем коллекции, какими типами ячеек она может распоряжаться.
//    // При попытке создать ячейку с незарегистрированным идентификатором коллекция выдаст ошибку.
//    collection.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
//    collection.backgroundColor = .lightGray
//    collection.dataSource = helper
//
//    PlaygroundPage.current.liveView = collection
//
//    collection.reloadData()
// 
//    
//    
//}
