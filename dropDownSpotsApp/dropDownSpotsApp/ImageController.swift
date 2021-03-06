//
//  ImageController.swift
//  dropDownSpotsApp
//
//  Created by Sabir Myrzaev on 13.02.2022.
//

import UIKit

class ImageController: UIViewController {
    
    var cellData: CellData? {
        didSet {
            self.imageView.image = cellData?.featureImage
            self.navigationItem.title = cellData?.title
        }
    }
    
    var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "zero")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        view.clipsToBounds = true
        
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    }
}
