//
//  TrackerCellViewController.swift
//  Tracker
//
//  Created by Олег Кор on 10.11.2024.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func completeTracker(_ trackerCell: TrackerCellViewController, id: UUID, trackerDone: Bool)
}

final class TrackerCellViewController: UICollectionViewCell {
    static let identifier = "trackerCell"
    
    weak var delegate: TrackerCellDelegate?
    
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
        label.textColor = .ypWhite
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    let emojiLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor.ypWhite.withAlphaComponent(0.3)
        label.textAlignment = .center
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
    private var trackerID: UUID?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .ypWhite
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
        
        cellView.addSubview(emojiLable)
        emojiLable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.heightAnchor.constraint(equalToConstant: 90),
            cellView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            titleLable.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -12),
            titleLable.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 12),
            titleLable.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -12),
            
            emojiLable.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 12),
            emojiLable.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 12),
            emojiLable.widthAnchor.constraint(equalToConstant: 24),
            emojiLable.heightAnchor.constraint(equalToConstant: 24),
            
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
        let imageName = trackerDone ? "Checkmark" : "plus"
        checkTrackerButton.setImage(UIImage(systemName: imageName), for: .normal)
        checkTrackerButton.alpha = trackerDone ? 0.3 : 1.0
        if let id = trackerID {
            delegate?.completeTracker(self, id: id, trackerDone: trackerDone)
            print("НОМЕР ТРЕКЕРА \(id)")
        }
    }
    
    func configure(with tracker: Tracker, completedCount: Int, isCompletedToday: Bool) {
        emojiLable.text = tracker.trackerEmoji
        titleLable.text = tracker.trackerName
        cellView.backgroundColor = tracker.trackerColor
        checkTrackerButton.backgroundColor = tracker.trackerColor
        trackerID = tracker.id
        daysCountLable.text = daysText(for: completedCount)
        let imageName = trackerDone ? "checkmark" : "plus"
        checkTrackerButton.setImage(UIImage(systemName: imageName), for: .normal)
        checkTrackerButton.alpha = trackerDone ? 0.3 : 1.0
        }
    
    private func daysText(for count: Int) -> String {
            let lastDigit = count % 10
            let lastTwoDigits = count % 100
            
            if lastTwoDigits >= 11 && lastTwoDigits <= 19 {
                return "\(count) дней"
            } else if lastDigit == 1 {
                return "\(count) день"
            } else if lastDigit >= 2 && lastDigit <= 4 {
                return "\(count) дня"
            } else {
                return "\(count) дней"
            }
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
