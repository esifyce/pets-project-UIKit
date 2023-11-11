//
//  MainViewController.swift
//  EncryptDemidLab1
//
//  Created by Krasivo on 06.10.2023.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let monoVC = UINavigationController(rootViewController: MonoAlghoritmViewController())
        let caesarVC = UINavigationController(rootViewController: CaesarAlghoritmViewController())
        let trithemiusVC = UINavigationController(rootViewController: TrithemiusAlghoritmViewController())
        
        setViewControllers([monoVC, caesarVC, trithemiusVC], animated: false)
        
        guard let items = self.tabBar.items else { return }
        
        monoVC.title = "Моноалфавит"
        caesarVC.title = "Цезарь"
        trithemiusVC.title = "Тритемиус"
        
        let images = ["contact.sensor", "c.circle", "t.circle"]
        
        for x in 0...2 {
            items[x].image = UIImage(systemName: images[x])
        }
        
        tabBar.tintColor = .black
    }
}
