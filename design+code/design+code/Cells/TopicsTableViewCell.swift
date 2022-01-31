//
//  TopicsTableViewCell.swift
//  design+code
//
//  Created by Sabir Myrzaev on 31.01.2022.
//

import UIKit

class TopicsTableViewCell: UITableViewCell {

    @IBOutlet var topicIcon: UIImageView!
    @IBOutlet var topicLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Accessibility
        topicLabel.font = UIFont.preferredFont(for: .body, weight: .bold)
        topicLabel.adjustsFontForContentSizeCategory = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
