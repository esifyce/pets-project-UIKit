//
//  BaseView.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import UIKit
import RxSwift

class BaseView: UIView {
    let disposeBag = DisposeBag()
    
    override var backgroundColor: UIColor? {
        willSet {
            let animation = CATransition()
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.type = CATransitionType.fade
            animation.duration = 1/4
            layer.add(animation, forKey: CATransitionType.fade.rawValue)
        }
    }
    
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
        applyLocalization()
    }
    
    func setupSubviews() {
        
    }
    
    func setupConstraints() {
        
    }
    
    func setupBindings() {
        
    }
    
    func applyLocalization() {
        
    }
}
