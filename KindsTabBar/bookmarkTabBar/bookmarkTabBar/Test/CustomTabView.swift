//
//  CustomTabView.swift
//  CustomTabbar
//
//  Created by Sabir Myrzaev on 21/3/22.
//

import UIKit

final class CustomTabView {
    static func customTabView(_ tabFrame: CGRect) -> CAShapeLayer? {
        let layer = CAShapeLayer()
        var bottomSafeAreaHeight: CGFloat = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows.first
            let safeFrame = window?.safeAreaLayoutGuide.layoutFrame
            bottomSafeAreaHeight = (window?.frame.maxY ?? 0) - (safeFrame?.maxY ?? 0)
        }
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -20)
        layer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: -30, width: tabFrame.width, height: (tabFrame.height + 30) + bottomSafeAreaHeight), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 30, height: 30)).cgPath
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -1)
        layer.shadowRadius = 15
        layer.shadowOpacity = 0.4
        layer.borderWidth = 1.0
        layer.opacity = 1
        layer.isHidden = false
        layer.masksToBounds = false
        layer.fillColor = UIColor.white.cgColor
        return layer
    }
}
