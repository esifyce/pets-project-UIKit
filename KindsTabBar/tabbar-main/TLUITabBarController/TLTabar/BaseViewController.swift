//
//  BaseViewController.swift
//  TLUITabBarController
//
//  Created by tangjilin on 2022/2/27.
//

import UIKit

class BaseViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addControllerVC()
    }
    

    func addControllerVC(){
        UITabBar.appearance().isTranslucent = false
        self.view.backgroundColor = UIColor(255,204,204)
        
        let home = TLHomeViewController.init()
        let nav1 = BaseNavViewController.init(rootViewController: home)
        
        let addVC = TLAddViewController.init()
        let nav2 = BaseNavViewController.init(rootViewController: addVC)
        
        let seting = TLSetingViewController.init()
        let nav3 = BaseNavViewController.init(rootViewController: seting)
        
        self.viewControllers = [nav1,nav2,nav3]
        
        nav1.tabBarItem = self.genrateTabBarItem(titel: "首页", imgName: "tabbarOne_normal", selectedimdName: "tabbarOne_selected")
        nav2.tabBarItem = self.genrateTabBarItem(titel: "类目", imgName: "tabbarTwo_normal", selectedimdName: "tabbarTwo_selected")
        nav3.tabBarItem = self.genrateTabBarItem(titel: "我的", imgName: "tabbarThree_normal", selectedimdName: "tabbarThree_selected")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        for i in 0 ... (self.tabBar.items?.count)!-1 {
            let itm = self.tabBar.items?[i]
            if i == 1 {
                itm?.imageInsets = UIEdgeInsets.init(top: -32, left: -10, bottom: -10, right: -10)
                
            }
        }
    }

    func genrateTabBarItem(titel:String,imgName:String,selectedimdName:String) -> UITabBarItem{
        let img = UIImage.init(named: imgName)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let setimg = UIImage.init(named: selectedimdName)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        return UITabBarItem.init(title: title, image: img, selectedImage: setimg)
    }
    
    
}
