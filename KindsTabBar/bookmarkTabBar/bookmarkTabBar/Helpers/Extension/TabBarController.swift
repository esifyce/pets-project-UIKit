//
//  TabBarController.swift
//  BipolarTabBar
//
//  Created by Sabir Myrzaev on 21/3/22.
//

import UIKit

class TabBarController: UITabBarController {
    
    private var viewLeadingConst: NSLayoutConstraint!
    var value: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create instance of view controllers
        let oneTB = UINavigationController(rootViewController: OneViewController())
        let secondTB = UINavigationController(rootViewController: SecondViewController())
        let thirdTB = UINavigationController(rootViewController: ThirdViewController())
        let testTB = UINavigationController(rootViewController: ThirdViewController())
        
        // set navbar window
        oneTB.navigationBar.setDefaultState()
        secondTB.navigationBar.setDefaultState()
        thirdTB.navigationBar.setDefaultState()
        
        // set text in title icon
//        oneTB.title = "graphic"
//        secondTB.title = "bipolar"
//        thirdTB.title = "pills"
        
        // assign vc to TabBar
        setViewControllers([oneTB, secondTB, thirdTB, testTB], animated: true)
        
        guard let items = self.tabBar.items else { return }
        
        let images = ["alternatingcurrent", "brain", "pills", "brain"]
        
        for i in 0...images.count - 1 {
            items[i].image = UIImage(systemName: images[i])
        }
        
        delegate = self
        DispatchQueue.main.async { [weak self] in
            self?.setupTabFont()
            self?.setupCustomTabBar()
            self?.setLayouts()
        }
    }
    
    private func setupCustomTabBar() {
        self.tabBar.layer.insertSublayer(CustomTabView.customTabView(tabBar.bounds) ?? CAShapeLayer(), at: 0)
        if let items = tabBar.items {
           let _ = items.map { tabItem in
                tabItem.imageInsets = UIEdgeInsets(top: -40, left: 0, bottom: 0, right: 0)
            }
        }
        tabBar.itemWidth = 60
        tabBar.itemPositioning = .centered
        selectedIndex = 3
    }
    
    private func setupTabFont() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .bold)], for: .selected)
    }
    
    private let profileView: UIView = {
        let profileView = UIView()
        profileView.tag = 0
        profileView.backgroundColor = Constants.profilePageColor
        profileView.tintColor = .white
        profileView.layer.cornerRadius = 18
        profileView.isUserInteractionEnabled = false
        profileView.layer.shadowColor = UIColor.gray.cgColor
        profileView.layer.shadowOffset = CGSize(width: 0, height: -1)
        profileView.layer.shadowRadius = 5
        profileView.layer.shadowOpacity = 0.3
        profileView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        profileView.translatesAutoresizingMaskIntoConstraints = false
        return profileView
    }()

    private let tabbarImage: UIImageView = {
        let tabImage = UIImageView()
        tabImage.contentMode = .scaleAspectFill
        tabImage.translatesAutoresizingMaskIntoConstraints = false
        tabImage.image = UIImage(systemName: "person.circle")
        return tabImage
    }()
    
    private let tabItemTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "person"
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.textColor = Constants.applabelColor
        return label
    }()
    
    private let userInfoTitle: UILabel = {
        let label = UILabel()
        label.text = "SK"
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = Constants.applabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setLayouts() {
        view.addSubview(profileView)
        profileView.addSubview(tabItemTitle)
        profileView.addSubview(userInfoTitle)
        profileView.addSubview(tabbarImage)
        NSLayoutConstraint.activate([
            profileView.widthAnchor.constraint(equalToConstant: tabBar.bounds.size.width / 5 - 3),
            profileView.heightAnchor.constraint(equalTo: tabBar.heightAnchor, constant: 43),
            profileView.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor),
            profileView.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor, constant: -20),
            tabbarImage.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -22),
            tabbarImage.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 10),
            tabbarImage.heightAnchor.constraint(equalToConstant: 33),
            tabbarImage.widthAnchor.constraint(equalToConstant: 33),
            userInfoTitle.centerYAnchor.constraint(equalTo: tabbarImage.centerYAnchor, constant: 2),
            userInfoTitle.leadingAnchor.constraint(equalTo: tabbarImage.trailingAnchor, constant: 3),
            tabItemTitle.topAnchor.constraint(equalTo: tabbarImage.bottomAnchor, constant: 1),
            tabItemTitle.leadingAnchor.constraint(equalTo: tabbarImage.leadingAnchor, constant: 8),
            tabItemTitle.trailingAnchor.constraint(equalTo: profileView.trailingAnchor)
        ])
    }
    
    //MARK: Use this Method to Move Yellow View Accross TabItems
    private func moveView(value: CGFloat) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            self.profileView.frame.origin.x = value
            self.view.layoutIfNeeded()
        })
    }
    
    private func calculateValueToMoveItem(_ selectedIndex: Int) {
        let itemWidth = Constants.screenWidth/CGFloat(4)
        let distanceToMove = itemWidth * CGFloat(selectedIndex)
        moveView(value: selectedIndex == 3 ? distanceToMove : distanceToMove + 20)
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //Uncomment this to move yellow view
        calculateValueToMoveItem(tabBarController.selectedIndex)
    }
}
