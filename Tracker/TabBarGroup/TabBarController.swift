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
        let localizedTrackerTitle = NSLocalizedString("trackersAppTitle", comment: "")
        let localizedStatisticTitle = NSLocalizedString("statisticAppTitle", comment: "")
        
        let trackerViewController = UINavigationController(rootViewController: TrackerViewController())
        trackerViewController.tabBarItem = UITabBarItem(title: localizedTrackerTitle,
                                                        image: UIImage(named: "TrackerTabImage"),
                                                        selectedImage: nil)
        
        let statisticViewController = UINavigationController(rootViewController: StatisticViewController())
        statisticViewController.tabBarItem = UITabBarItem(title: localizedStatisticTitle,
                                                        image: UIImage(named: "StatisticTabImage"),
                                                        selectedImage: nil)
        
        self.viewControllers = [trackerViewController, statisticViewController]
        
        let lineLayer = CALayer()
        lineLayer.backgroundColor = UIColor.ypTBGray.cgColor
        lineLayer.frame = CGRect(x: 0, y: 0, width: self.tabBar.bounds.width, height: 1)
        self.tabBar.layer.addSublayer(lineLayer)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let tabBarTitle = viewController.tabBarItem.title else {return}
        print("Выбрана страница \(tabBarTitle)")
    }
    
  
}
