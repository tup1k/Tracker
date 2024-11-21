//
//  UnregularCollectionViewCell.swift
//  Tracker
//
//  Created by Олег Кор on 22.11.2024.
//

import UIKit

final class UnregularCollectionViewCell: UICollectionViewCell {
    static let identifier = "unregularCell"
    
    /// Лейбл для эмоджи или цвета
    let collectionLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cellContraint()
    }
    
    private func cellContraint() {
        contentView.addSubview(collectionLable)
        collectionLable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            collectionLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            collectionLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            collectionLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
