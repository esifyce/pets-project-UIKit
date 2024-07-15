//
//  BaseCollectionViewCell.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import UIKit
import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {
    
    var disposeBag: DisposeBag?
    
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
    }
    
    func setupSubviews() {
        
    }
    
    func setupConstraints() {
        
    }
    
    func setupBindings() {
        
    }
}
