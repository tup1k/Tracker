//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Олег Кор on 27.10.2024.
//

import UIKit

final class TrackerViewController: UIViewController {
    private let viewControllerName = UILabel()
    private let plusTrackerButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "TrackerViewController"
        view.backgroundColor = .green
        addTrackerTitle()
//        addTrackerPlusButton()
        
        self.setNavigationBar()
        
    }
    
    
    func setNavigationBar() {
        view.addSubview(plusTrackerButton)
        plusTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        plusTrackerButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusTrackerButton.accessibilityIdentifier = "plusTrackerButton"
        
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 45, width: screenSize.width, height: 42))
        let navItem = UINavigationItem(title: "Тест")
        let doneItem = UIBarButtonItem(customView: plusTrackerButton)
        navItem.leftBarButtonItem = doneItem
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }

    @objc func done() { // remove @objc for Swift 3

    }
    
    
    private func addTrackerTitle() {
        view.addSubview(viewControllerName)
        viewControllerName.translatesAutoresizingMaskIntoConstraints = false
        viewControllerName.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        viewControllerName.text = "Трекер"
        NSLayoutConstraint.activate([
            viewControllerName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            viewControllerName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60)
        ])
    }
    
    private func addTrackerPlusButton() {
        view.addSubview(plusTrackerButton)
        plusTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        plusTrackerButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusTrackerButton.accessibilityIdentifier = "plusTrackerButton"
        
        var plusBarTrackerButton = UIBarButtonItem(customView: plusTrackerButton)
        self.navigationItem.leftBarButtonItem = plusBarTrackerButton
        
    }
    
    
    
}
