//
//  AppDelegate.swift
//  TLUITabBarController
//
//  Created by tangjilin on 2022/2/27.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        
        
        let nav = BaseNavViewController.init(rootViewController: BaseViewController.init())
        
        self.window?.rootViewController = nav
        
        
        
        
        
        
        self.window?.makeKeyAndVisible()
        
        
        return true
    }

   


}

