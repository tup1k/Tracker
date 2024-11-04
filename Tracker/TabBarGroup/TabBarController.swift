//
//  TabBar.swift
//  Tracker
//
//  Created by Олег Кор on 27.10.2024.
//

import UIKit
final class TabBarController: UITabBarController, UITabBarControllerDelegate {
//    override func awakeFromNib() {
//        super.awakeFromNib()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.tabBar.backgroundColor = UIColor.white
    
        let trackerViewController = TrackerViewController()
        trackerViewController.tabBarItem = UITabBarItem(title: "Трекеры",
                                                        image: UIImage(named: "TrackerTabImage"),
                                                        selectedImage: nil)
        
        let statisticViewController = StatisticViewController()
        statisticViewController.tabBarItem = UITabBarItem(title: "Статистика",
                                                        image: UIImage(named: "StatisticTabImage"),
                                                        selectedImage: nil)
        
        
        self.viewControllers = [trackerViewController, statisticViewController]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(viewController.title)")
    }
    
  
}
