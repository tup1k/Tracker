//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Олег Кор on 27.10.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let userDefaults: UserDefaults = .standard

    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let notFirstStart = userDefaults.bool(forKey: "notFirstStart")
      
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        if notFirstStart {
            let initialViewController = TabBarController()
            window?.rootViewController = initialViewController
        } else {
            let initialViewController = OnboardingViewController()
            window?.rootViewController = initialViewController
        }
        
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
      
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
       
    }

    func sceneWillResignActive(_ scene: UIScene) {
       
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
       
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
      
    }


}

