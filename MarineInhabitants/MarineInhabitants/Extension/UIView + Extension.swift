//
//  UIView + Extension.swift
//  MarineInhabitants
//
//  Created by Sabir Myrzaev on 29/4/22.
//

import UIKit

extension UIView {

    func apply(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, marginTop: CGFloat? = 0,
                marginLeft: CGFloat? = 0, marginBottom: CGFloat? = 0, marginRight: CGFloat? = 0, width: CGFloat? = nil, height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: marginTop!).isActive = true
        }
        
        if let left = left {
            leadingAnchor.constraint(equalTo: left, constant: marginLeft!).isActive = true
        }
        
        if let bottom = bottom {
            if let marginBottom = marginBottom {
                bottomAnchor.constraint(equalTo: bottom, constant: -marginBottom).isActive = true
            }
        }
        
        if let right = right {
            if let marginRight = marginRight {
                trailingAnchor.constraint(equalTo: right, constant: -marginRight).isActive = true
            }
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func updateConstraint(attribute: NSLayoutConstraint.Attribute, constant: CGFloat) -> Void {
        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
            constraint.constant = constant
            self.layoutIfNeeded()
        }
    }
    
    func center(inView view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func centerX(inView view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func centerY(inView view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
