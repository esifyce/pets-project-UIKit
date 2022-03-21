//
//  TLColor+color.swift
//  TLUITabBarController
//
//  Created by tangjilin on 2022/2/27.
//

import Foundation
import UIKit

extension UIColor{
    /// 使用rgb方式生成自定义颜色
    convenience init(_ r : CGFloat, _ g : CGFloat, _ b: CGFloat){
        let red = r / 255.0
        let green = g / 255.0
        let blue = b / 255.0
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    convenience init(_ r : CGFloat, _ g : CGFloat, _ b : CGFloat, _ a : CGFloat){
        let red = r / 255.0
        let green = g / 255.0
        let blue = b / 255.0
        self.init(red:red, green:green, blue:blue, alpha:a)
    }
}
