//
//  TrackerCellViewController.swift
//  Tracker
//
//  Created by Олег Кор on 10.11.2024.
//

import UIKit

final class TrackerCellViewController: UICollectionViewCell {
    static let identifier = "trackerCell"
    
    let cellView: UIView = {
        let myView = UIView()
        myView.backgroundColor = .green
        myView.layer.cornerRadius = 16
        myView.layer.masksToBounds = true
        return myView
    }()
    
    let titleLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let daysCountLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    let checkTrackerButton: UIButton = {
        let button = UIButton()
        let buttonImageNormal = UIImage(systemName: "plus")
        button.backgroundColor = .green
        button.layer.cornerRadius = 17
        button.setImage(buttonImageNormal, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(checkTrackerButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var trackerDone: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        titleLable.preferredMaxLayoutWidth = cellView.bounds.width
        
        cellContraint()
    }
    
    private func cellContraint() {
        [cellView,
         daysCountLable,
         checkTrackerButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        cellView.addSubview(titleLable)
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.heightAnchor.constraint(equalToConstant: 90),
            
            titleLable.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -12),
            titleLable.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 12),
            
            daysCountLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            daysCountLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            checkTrackerButton.widthAnchor.constraint(equalToConstant: 34),
            checkTrackerButton.heightAnchor.constraint(equalToConstant: 34),
            checkTrackerButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            checkTrackerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    @objc func checkTrackerButtonPressed() {
       trackerDone = !trackerDone
        let imageName = trackerDone ? "checkmark" : "plus"
        checkTrackerButton.setImage(UIImage(systemName: imageName), for: .normal)
//        checkTrackerButton.isSelected.toggle()
        checkTrackerButton.alpha = trackerDone ? 0.3 : 1.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
