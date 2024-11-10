//
//  HabitCategoryViewController.swift
//  Tracker
//
//  Created by Олег Кор on 09.11.2024.
//

import UIKit

final class HabitCategoryViewController: UIViewController {
    
        
        // Заголовок
        private let categoryTitle: UILabel = {
            let label = UILabel()
            label.text = "Категория"
            label.font = .systemFont(ofSize: 16, weight: .medium)
            return label
        }()
        
        // Кнопка создания привычки
        private let createCategoryButton: UIButton = {
            let button = UIButton()
            button.setTitle("Добавить категорию", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .black
            button.accessibilityIdentifier = "createCategoruButton"
            button.layer.cornerRadius = 16
            button.addTarget(self, action: #selector(categoryButtonPressed), for: .touchUpInside)
            return button
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.accessibilityIdentifier = "HabitCategoryVC"
            view.backgroundColor = .white
            
            view.addSubview(categoryTitle)
            categoryTitle.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(createCategoryButton)
            createCategoryButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                categoryTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 78),
                categoryTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                createCategoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                createCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 50),
                createCategoryButton.heightAnchor.constraint(equalToConstant: 60),
                createCategoryButton.widthAnchor.constraint(equalToConstant: 335)
            ])
        }
        
        @objc func categoryButtonPressed() {
//            let controller = HabitViewController()
//            self.present(controller, animated: true, completion: nil)
        }
}
