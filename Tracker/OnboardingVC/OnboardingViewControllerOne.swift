//
//  OnboardingViewControllerOne.swift
//  Tracker
//
//  Created by Олег Кор on 08.12.2024.
//

import UIKit

final class OnboardingViewControllerOne: UIViewController {
    private let userDefaults: UserDefaults = .standard
    
    private lazy var onboardingScreen: UIImageView = {
        let image = UIImageView()
        let onboardingImage = UIImage.onboardingScreenOne
        image.image = onboardingImage
       
        return image
    }()
    
    /// Заголовок окна создания привычки
    private lazy var onboardingTitle: UILabel = {
        let label = UILabel()
        label.text = "Отслеживайте только \nто, что хотите"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    /// Кнопка создания категории
    private lazy var onboardingButtonOne: UIButton = {
        let button = UIButton()
        button.setTitle("Вот это технологии!", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.accessibilityIdentifier = "onboardingButtonOne"
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(onboardingButtonOnePressed), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
    }
    
    /// Метод создания UI
    private func createView() {
        view.insertSubview(onboardingScreen, at: 0)
        view.addSubview(onboardingTitle)
        view.addSubview(onboardingButtonOne)
        
        onboardingScreen.translatesAutoresizingMaskIntoConstraints = false
        onboardingTitle.translatesAutoresizingMaskIntoConstraints = false
        onboardingButtonOne.translatesAutoresizingMaskIntoConstraints = false
  
        
        NSLayoutConstraint.activate([
            onboardingScreen.topAnchor.constraint(equalTo: view.topAnchor),
            onboardingScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            onboardingScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            onboardingScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            onboardingTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            onboardingTitle.bottomAnchor.constraint(equalTo: onboardingButtonOne.topAnchor, constant: -160),
            onboardingTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            onboardingTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            
            onboardingButtonOne.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            onboardingButtonOne.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            onboardingButtonOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            onboardingButtonOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            onboardingButtonOne.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func onboardingButtonOnePressed() {
        let controller = TabBarController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
        userDefaults.setValue(true, forKey: "notFirstStart")
        
        if let window = UIApplication.shared.windows.first {
            let initialViewController = TabBarController()
            window.rootViewController = initialViewController
        }
    }
}
