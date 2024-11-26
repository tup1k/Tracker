//
//  ColorsCollectionViewCell.swift
//  Tracker
//
//  Created by Олег Кор on 06.11.2024.
//

import UIKit



class ColorsCollectionViewCell: UICollectionViewCell {
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {                  // 1
        super.init(frame: frame)                    // 2
        
        contentView.addSubview(titleLabel)          // 3
        titleLabel.translatesAutoresizingMaskIntoConstraints = false    // 4
        
        
        NSLayoutConstraint.activate([                                    // 5
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
                                    ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


