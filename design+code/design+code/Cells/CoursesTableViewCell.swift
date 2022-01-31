//
//  CoursesTableViewCell.swift
//  design+code
//
//  Created by Sabir Myrzaev on 31.01.2022.
//

import UIKit

class CoursesTableViewCell: UITableViewCell {

    @IBOutlet var logo: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var descriptionlabel: UILabel!
    @IBOutlet var banner: UIImageView!
    @IBOutlet var background: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(named: "Shadow")!.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 10
        layer.masksToBounds = false
        layer.cornerRadius = 30
        
        // Accessibility
        titleLabel.font = UIFont.preferredFont(for: .title1, weight: .bold)
        titleLabel.adjustsFontForContentSizeCategory = true
        
        subtitleLabel.font = UIFont.preferredFont(for: .footnote, weight: .semibold)
        subtitleLabel.adjustsFontForContentSizeCategory = true
        
        descriptionlabel.font = UIFont.preferredFont(for: .footnote, weight: .regular)
        descriptionlabel.adjustsFontForContentSizeCategory = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
