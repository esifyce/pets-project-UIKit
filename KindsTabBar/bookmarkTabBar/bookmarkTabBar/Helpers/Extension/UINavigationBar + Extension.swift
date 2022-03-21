//
//  UINavigationBar + Extension.swift
//  BipolarTabBar
//
//  Created by Sabir Myrzaev on 21/3/22.
//

import UIKit

extension UINavigationBar {
    static let defaultBackgroundColor = UIColor.white
    static let defaultTintColor = UIColor.black
    
    func setTranslucent(tintColor: UIColor, titleColor: UIColor) {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.titleTextAttributes = [.foregroundColor: titleColor]
            standardAppearance = appearance
            scrollEdgeAppearance = appearance
        } else {
            titleTextAttributes = [.foregroundColor: titleColor]
            setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            shadowImage = UIImage()
        }
        isTranslucent = true
        self.tintColor = tintColor
    }
    
    func setDefaultState() {
        isTranslucent = false
        clipsToBounds = false
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UINavigationBar.defaultBackgroundColor
            appearance.titleTextAttributes = [.foregroundColor: UINavigationBar.defaultTintColor]
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.defaultPrompt)
            shadowImage = UIImage()
            barTintColor = UINavigationBar.defaultBackgroundColor
            titleTextAttributes = [.foregroundColor: UINavigationBar.defaultTintColor]
        }
        
        tintColor = UINavigationBar.defaultTintColor
    }
}
