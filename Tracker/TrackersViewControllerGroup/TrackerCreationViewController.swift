//
//  TrackerTypeViewController.swift
//  Tracker
//
//  Created by Олег Кор on 01.11.2024.
//

import UIKit

final class TrackerCreationViewController: UIViewController {
    
    // Заголовок
    private let viewControllerName: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    // Кнопка создания привычки
    private let habitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.accessibilityIdentifier = "habitButton"
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(habitButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // Кнопка создания привычки
    private let unregularButton: UIButton = {
        let button = UIButton()
        button.setTitle("Нерегулярное событие", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.accessibilityIdentifier = "unregularButton"
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(unregularButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(viewControllerName)
        viewControllerName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
           // viewControllerName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            viewControllerName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 88),
            viewControllerName.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.accessibilityIdentifier = "TrackerCreationVC"
        view.backgroundColor = .white
        
        view.addSubview(habitButton)
        view.addSubview(unregularButton)
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        unregularButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            habitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            unregularButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:395),
            unregularButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:471),
            habitButton.widthAnchor.constraint(equalToConstant: 335),
            unregularButton.widthAnchor.constraint(equalToConstant: 335),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            unregularButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        
    }
    
    @objc func habitButtonPressed() {
        
    }
    
    @objc func unregularButtonPressed() {
        
    }
    
}
