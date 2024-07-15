//
//  BaseLabel.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import UIKit

class BaseLabel: UILabel {
   
    var textEdgeInsets = UIEdgeInsets.zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var text: String? {
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
        setupBaseUI()
    }
    
    func setupSubviews() {
        
    }
    
    func setupConstraints() {
        
    }
    
    func setupBindings() {
        
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textEdgeInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textEdgeInsets.top, left: -textEdgeInsets.left, bottom: -textEdgeInsets.bottom, right: -textEdgeInsets.right)
        return textRect.inset(by: invertedInsets)
    }
        
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textEdgeInsets))
    }
    
    private func setupBaseUI() {
        numberOfLines = 0
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.1
        lineBreakMode = .byClipping
    }
   
    func setInsets(left: CGFloat, right: CGFloat, top: CGFloat = 0, bottom: CGFloat = 0) {
        textEdgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
}
