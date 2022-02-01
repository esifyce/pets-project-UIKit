//
//  RestaurantDetailViewController.swift
//  Task-4
//
//  Created by Sabir Myrzaev on 25.09.2021.
//

import UIKit

class RestaurantDetailViewController: UIViewController {

    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var restaurantName: UILabel!
    @IBOutlet var restaurantType: UILabel!
    @IBOutlet var restaurantLocation: UILabel!


    
    
    var restaurantImageName = ""
    var restaurantNames = ""
    var restaurantTypes = ""
    var restaurantLocations = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        restaurantImageView.image = UIImage(named: restaurantImageName)
        restaurantName.text = restaurantNames
        restaurantType.text = restaurantTypes
        restaurantLocation.text = restaurantLocations
        
        navigationItem.largeTitleDisplayMode = .never

    }
    


}
