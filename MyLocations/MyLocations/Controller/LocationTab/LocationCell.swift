//
//  LocationCell.swift
//  MyLocations
//
//  Created by Sabir Myrzaev on 21.06.2021.
//

import UIKit

class LocationCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photoImageView.layer.cornerRadius = photoImageView.bounds.size.width / 2
        photoImageView.clipsToBounds = true
        separatorInset = UIEdgeInsets(top: 0, left: 82, bottom: 0, right: 0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func thumbnail(for location: Location) -> UIImage {
        if location.hasPhoto, let image = location.photoImage {
            return image.resized(withBounds: CGSize(width: 52, height: 52))
        }
        return UIImage(named: "No Photo") ?? UIImage()
    }
    
    func configure(for location: Location) {
        
        if location.locationDescription.isEmpty {
            descriptionLabel.text = "Not description"
        } else {
            descriptionLabel.text = location.locationDescription
        }
        
        if let placemark = location.placemark {
            var text = ""
            
            text.add(text: placemark.subThoroughfare)
            text.add(text: placemark.thoroughfare, separatorFor: ", ")
            text.add(text: placemark.locality, separatorFor: ", " )
            
            addressLabel.text = text
        } else {
            addressLabel.text = String(format: "Longitude: %.8f, Latitude: %.8f", location.longitude, location.latitude)
        }
        photoImageView.image = thumbnail(for: location)
    }
}
