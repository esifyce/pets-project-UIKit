//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Sabir Myrzaev on 27.06.2021.
//

import UIKit

class SearchResultCell: UITableViewCell {

    var downloadTask: URLSessionDownloadTask?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(named: "SearchBar")?.withAlphaComponent(0.5)
        selectedBackgroundView = selectedView

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
    }

    // MARK: - Helper methods
    func configure(for result: SearchResult) {
        nameLabel.text = result.name
        if result.artist.isEmpty {
            artistNameLabel.text = "Unknown"
        } else {
            artistNameLabel.text = String(format: "%@ (%@)", result.artist, result.type)
        }
        artworkImageView.image = UIImage(systemName: "square")
        if let smallURL = URL(string: result.imageSmall) {
            downloadTask = artworkImageView.loadImage(url: smallURL)
        }
    }
}
        
