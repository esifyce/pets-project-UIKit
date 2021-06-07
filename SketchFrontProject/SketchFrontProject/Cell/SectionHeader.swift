//
//  SectionHeader.swift
//  SketchFrontProject
//
//  Created by Sabir Myrzaev on 07.06.2021.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    
    static let reuseId = "SectionHeader"
    
    let titleLable = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGroupedBackground
        
        titleLable.font = UIFont.sfProRounded(offsize: 18, weight: .semibold)
        titleLable.textColor = #colorLiteral(red: 0.4015320539, green: 0.3991499543, blue: 0.4033662081, alpha: 1)
        
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLable)
        
        NSLayoutConstraint.activate([
            titleLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLable.topAnchor.constraint(equalTo: topAnchor),
            titleLable.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLable.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = frame.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not implemented")
    }
}
