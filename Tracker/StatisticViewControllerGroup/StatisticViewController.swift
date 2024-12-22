//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Олег Кор on 27.10.2024.
//

import UIKit

final class StatisticViewController: UIViewController {
    /// Картинка для заглушки
    private lazy var statisticPlaceholderImage: UIImageView = {
        let image = UIImageView()
        let placeholder = UIImage.statisticPlaceholder
        image.image = placeholder
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    /// Текст для заглушки
    private lazy var statisticPlaceholderLabel: UILabel = {
        let label = UILabel()
        let localizedStatisticPlaceholderTitle = NSLocalizedString("statisticPlaceholder", comment: "")
        label.text = localizedStatisticPlaceholderTitle
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        commonStatisticVCConstraint()
    }
    
    /// Настройки навибара
    private func setNavigationBar() {
        let localizedStatisticsTitle = NSLocalizedString("statisticsAppTitle", comment: "")
        self.navigationItem.title = localizedStatisticsTitle
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    /// Привязка элементов к экрану
    private func commonStatisticVCConstraint() {
        view.accessibilityIdentifier = "StatisticViewController"
        view.backgroundColor = .ypWhite
        
        view.addSubview(statisticPlaceholderImage)
        view.addSubview(statisticPlaceholderLabel)
//        view.addSubview(trackerCollectionView)
        
        NSLayoutConstraint.activate([
            statisticPlaceholderImage.widthAnchor.constraint(equalToConstant: 80),
            statisticPlaceholderImage.heightAnchor.constraint(equalToConstant: 80),
            
            statisticPlaceholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statisticPlaceholderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
           
            statisticPlaceholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statisticPlaceholderLabel.topAnchor.constraint(equalTo: statisticPlaceholderImage.bottomAnchor, constant: 8),
           
//            trackerCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            trackerCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            trackerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            trackerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}
