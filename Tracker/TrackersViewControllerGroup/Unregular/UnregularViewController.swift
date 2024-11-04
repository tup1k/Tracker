//
//  UnregularViewController.swift
//  Tracker
//
//  Created by Олег Кор on 03.11.2024.
//

import UIKit

final class UnregularViewController: UIViewController {
    // Заголовок
    private let viewControllerName: UILabel = {
        let label = UILabel()
        label.text = "Новое нерегулярное событие"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.accessibilityIdentifier = "UnregularVC"
        view.backgroundColor = .white
        
        view.addSubview(viewControllerName)
        viewControllerName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewControllerName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 78),
            viewControllerName.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
}
