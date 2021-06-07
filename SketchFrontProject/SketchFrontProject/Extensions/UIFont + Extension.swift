//
//  UIFont + Extension.swift
//  SketchFrontProject
//
//  Created by Sabir Myrzaev on 07.06.2021.
//

import UIKit

extension UIFont {
    
    enum RoundedWeight {
        case regular
        case medium
        case semibold
    }
    
    static func sfProRounded(offsize size: CGFloat, weight: RoundedWeight) -> UIFont? {
        switch weight {
        case .regular:
            return UIFont.init(name: "SFProRounded-Regular", size: size)
        case .medium:
            return UIFont.init(name: "SFProRounded-Medium", size: size)
        case .semibold:
            return UIFont.init(name: "SFProRounded-Semibold", size: size)
        }
    }
}
