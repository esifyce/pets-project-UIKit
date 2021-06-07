//
//  MainTabBarController.swift
//  SketchFrontProject
//
//  Created by Sabir Myrzaev on 07.06.2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contactsVC = ContactsViewController()
        let recentVC = RecentViewController()
        
        let contactsImage = UIImage(systemName: "person.crop.circle")!
        let recentImage = UIImage(systemName: "clock.fill")!
        
        viewControllers = [
            generateNavigationController(rootVC: contactsVC, title: "Contacts", image: contactsImage),
            generateNavigationController(rootVC: recentVC, title: "Recent", image: recentImage),

        ]
    }
    
    // функция для заполнения tab bar
    private func generateNavigationController(rootVC: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootVC)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}
