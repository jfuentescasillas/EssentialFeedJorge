//
//  AppDelegate.swift
//  EssentialAppJorge
//
//  Created by jfuentescasillas on 16/11/23.
//


import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        
        #if DEBUG
        config.delegateClass = DebuggingSceneDelegate.self
        #endif
        
        return config
    }
}
