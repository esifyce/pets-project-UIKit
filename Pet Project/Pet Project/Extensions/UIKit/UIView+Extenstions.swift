//
//  UIView+Extenstions.swift
//  Pet Project
//
//  Created by Sultan on 30/12/22.
//

import UIKit

extension UIView {
    
    typealias ListOfViews = () -> ([UIView])
    func add(@SubviewBuilder _ views: ListOfViews) {
        views().forEach(addSubview)
    }
    
    @resultBuilder
    struct SubviewBuilder {
        static func buildBlock(_ components: UIView...) -> [UIView] {
            components
        }
    }
}
