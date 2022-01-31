//
//  SectionsTableViewCell.swift
//  design+code
//
//  Created by Sabir Myrzaev on 31.01.2022.
//

import UIKit

class SectionsTableViewCell: UITableViewCell {
    
    @IBOutlet var sectionLogo: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var descriptionlabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Accessibility
        titleLabel.font = UIFont.preferredFont(for: .headline, weight: .bold)
        titleLabel.adjustsFontForContentSizeCategory = true
        
        subtitleLabel.font = UIFont.preferredFont(for: .caption1, weight: .semibold)
        subtitleLabel.adjustsFontForContentSizeCategory = true
        
        descriptionlabel.font = UIFont.preferredFont(for: .caption1, weight: .regular)
        descriptionlabel.adjustsFontForContentSizeCategory = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
