//
//  AppDelegate.swift
//  Tracker
//
//  Created by Олег Кор on 27.10.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
      
        let sceneConfiguration = UISceneConfiguration(name: "Main", sessionRole: connectingSceneSession.role)
               sceneConfiguration.delegateClass = SceneDelegate.self
        
       
               return sceneConfiguration
        
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
      
    }


}

