//
//  TrackerTypeViewController.swift
//  Tracker
//
//  Created by Олег Кор on 01.11.2024.
//

import UIKit

protocol TrackerCreationViewControllerDelegate: AnyObject {
    func didSelectHabbitType(trackerType: String)
    func didSelectUnregularType(trackerType: String)
}

final class TrackerCreationViewController: UIViewController {
    
    weak var delegate:TrackerCreationViewControllerDelegate?
    
    /// Заголовок окна выбора типа трекера
    private lazy var viewControllerName: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    /// Кнопка создания привычки
    private lazy var habitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .ypBlack
        button.accessibilityIdentifier = "habitButton"
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(habitButtonPressed), for: .touchUpInside)
        button.tag = 1
        return button
    }()
    
    // Кнопка создания нерегулярного события
    private lazy var unregularButton: UIButton = {
        let button = UIButton()
        button.setTitle("Нерегулярное событие", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .ypBlack
        button.accessibilityIdentifier = "unregularButton"
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(unregularButtonPressed), for: .touchUpInside)
        button.tag = 2
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        habitVCConstrait()
    }
        
    /// Привязка элементов к экрану
    private func habitVCConstrait() {
        [viewControllerName,
         habitButton,
         unregularButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.accessibilityIdentifier = "TrackerCreationVC"
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            viewControllerName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            viewControllerName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            habitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habitButton.topAnchor.constraint(equalTo: viewControllerName.bottomAnchor, constant:281),
            habitButton.widthAnchor.constraint(equalToConstant: 335),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            
            unregularButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            unregularButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant:16),
            unregularButton.widthAnchor.constraint(equalToConstant: 335),
            unregularButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc private func habitButtonPressed() {
        let controller = HabitViewController()
        controller.delegate = delegate as? any AddNewTrackerViewControllerDelegate
        controller.trackerType = "Habbit"
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc private func unregularButtonPressed() {
        let controller = HabitViewController()
        controller.delegate = delegate as? any AddNewTrackerViewControllerDelegate
        controller.trackerType = "Event"
        self.present(controller, animated: true, completion: nil)
    }
    
}
