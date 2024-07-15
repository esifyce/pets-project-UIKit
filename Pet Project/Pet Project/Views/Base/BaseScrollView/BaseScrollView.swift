//
//  BaseScrollView.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import UIKit

class BaseScrollView: UIScrollView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        setupSubviews()
        setupConstraints()
        setupBindings()
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        keyboardDismissMode = .onDrag
    }
    
    func setupSubviews() {
        
    }
    
    func setupConstraints() {
        
    }
    
    func setupBindings() {
        
    }
}
