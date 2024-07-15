//
//  BaseTableViewCell.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import UIKit
import RxSwift

class BaseTableViewCell: UITableViewCell {
    
    var disposeBag: DisposeBag?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
