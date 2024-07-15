//
//  BaseButton.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import UIKit

class BaseButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.1
        titleEdgeInsets = .init(top: 0, left: 5, bottom: 0, right: 5)
        titleLabel?.lineBreakMode = .byClipping
    }
}
