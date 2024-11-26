//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Олег Кор on 27.10.2024.
//

import UIKit

final class StatisticViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationBar()
    }
    
    /// Настройки навибара
    private func setNavigationBar() {
        self.navigationItem.title = "Статистика"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
