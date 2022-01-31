//
//  SectionsCollectionViewCell.swift
//  design+code
//
//  Created by Sabir Myrzaev on 31.01.2022.
//

import UIKit

class SectionsCollectionViewCell: UICollectionViewCell {
        
        @IBOutlet weak var banner: UIImageView!
        @IBOutlet weak var logo: CustomImageView!
        @IBOutlet weak var titleLabel: UILabel!
        @IBOutlet weak var subtitleLabel: UILabel!
        
        override public func layoutSubviews() {
            super.layoutSubviews()
            super.layoutIfNeeded()
        }
        
        override public func awakeFromNib() {
            super.awakeFromNib()
            
            layer.shadowColor = UIColor(named: "Shadow")?.cgColor
            layer.shadowOpacity = 0.25
            layer.shadowOffset = CGSize(width: 0, height: 5)
            layer.shadowRadius = 10
            layer.masksToBounds = false
            layer.cornerRadius = 30
            layer.cornerCurve = .continuous
            
            // Accessibility
            titleLabel.font = UIFont.preferredFont(for: .body, weight: .bold)
            titleLabel.adjustsFontForContentSizeCategory = true
            
            subtitleLabel.font = UIFont.preferredFont(for: .caption1, weight: .regular)
            subtitleLabel.adjustsFontForContentSizeCategory = true
        }
        
        override public func prepareForReuse() {
            super.prepareForReuse()
    }
}
