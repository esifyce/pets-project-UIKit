//
//  RestaurantDetailTwoColumnCell.swift
//  FoodPin
//
//  Created by Sabir Myrzaev on 30/3/22.
//

import UIKit

class RestaurantDetailTwoColumnCell: UITableViewCell {

    @IBOutlet var column1TitleLabel: UILabel! {
        didSet {
            column1TitleLabel.text = column1TitleLabel.text?.uppercased()
            column1TitleLabel.numberOfLines = 0
            column1TitleLabel.adjustsFontForContentSizeCategory = true
        }
    }
    @IBOutlet var column1TextLabel: UILabel! {
        didSet {
            column1TextLabel.numberOfLines = 0
            column1TextLabel.adjustsFontForContentSizeCategory = true
        }
    }
    @IBOutlet var column2TitleLabel: UILabel! {
        didSet {
            column2TitleLabel.text = column2TitleLabel.text?.uppercased()
            column2TitleLabel.numberOfLines = 0
            column2TitleLabel.adjustsFontForContentSizeCategory = true
        }
    }
    @IBOutlet var column2TextLabel: UILabel! {
        didSet {
            column2TextLabel.numberOfLines = 0
            column2TextLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
