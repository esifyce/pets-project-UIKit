//
//  AppDelegate.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import UIKit
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let container = Dependency.container

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = Dependency.resolve(with: UIWindow.self, with: .mainWindow)
        let root = Dependency.resolve(with: IMainViewController.self)
        window.rootViewController = BaseNavigationController(rootViewController: root)
        window.makeKeyAndVisible()
        return true
    }
}

