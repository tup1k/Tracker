//
//  TabBar.swift
//  Tracker
//
//  Created by Олег Кор on 27.10.2024.
//

import UIKit
final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarSetup()
    }
    
    /// Настройки таббара
    private func tabBarSetup() {
        let trackerViewController = UINavigationController(rootViewController: TrackerViewController())
        trackerViewController.tabBarItem = UITabBarItem(title: "Трекеры",
                                                        image: UIImage(named: "TrackerTabImage"),
                                                        selectedImage: nil)
        
        let statisticViewController = UINavigationController(rootViewController: StatisticViewController())
        statisticViewController.tabBarItem = UITabBarItem(title: "Статистика",
                                                        image: UIImage(named: "StatisticTabImage"),
                                                        selectedImage: nil)
        
        self.viewControllers = [trackerViewController, statisticViewController]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let tabBarTitle = viewController.tabBarItem.title else {return}
        print("Выбрана страница \(tabBarTitle)")
    }
    
  
}
