//
//  HabitScheduleViewController.swift
//  Tracker
//
//  Created by Олег Кор on 10.11.2024.
//

import UIKit

final class HabitScheduleViewController: UIViewController {
    // Заголовок
    private let scheduleTitle: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    private var mondayToggle = UISwitch()
        
            
                
        
        
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.accessibilityIdentifier = "HabitScheduleVC"
        view.backgroundColor = .white
        
        view.addSubview(scheduleTitle)
        scheduleTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scheduleTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 78),
            scheduleTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        // Set the position and size of the toggle button
        mondayToggle.frame = CGRect(x: 150, y: 200, width: 0, height: 0)
        
        // Add target action for value change event
        mondayToggle.addTarget(self, action: #selector(toggleButtonChanged), for: .valueChanged)
        
        // Add the toggle button to the view
        self.view.addSubview(mondayToggle)

        
    }
    
    @objc func toggleButtonChanged(sender: UISwitch) {
        if sender.isOn {
            print("Toggle button is ON")
        } else {
            print("Toggle button is OFF")
        }
    }
    
}
