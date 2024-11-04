//
//  HabitViewController.swift
//  Tracker
//
//  Created by Олег Кор on 04.11.2024.
//

import UIKit

final class HabitViewController: UIViewController {
    
    // Заголовок
    private let viewControllerName: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.accessibilityIdentifier = "HabitVC"
        view.backgroundColor = .white
        
        
        view.addSubview(viewControllerName)
        viewControllerName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewControllerName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 78),
            viewControllerName.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
