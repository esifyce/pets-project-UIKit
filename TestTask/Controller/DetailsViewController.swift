//
//  DetailsViewController.swift
//  TestTask
//
//  Created by Sabir Myrzaev on 10.07.2021.
//

import UIKit
import DropDown

class DetailsViewController: UITableViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var dropDownCategoryView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dropDownDeliveryView: UIView!
    @IBOutlet weak var deliveryLabel: UILabel!
    
    let dropDown = DropDown()
    
    let dropDownCategory = ["Burger", "Hotdog", "Cola", "Desserts"]
    let dropDownDelivery = ["Courier", "Catering", "Pickup", "Curbside"]
    
    
    // MARK: - VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Actions
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dropDownCategoryButton(_ sender: UIButton) {
        
        dropDown.anchorView = dropDownCategoryView
        dropDown.dataSource = dropDownCategory
        
        dropDownSize(byX: 0, byY: (dropDown.anchorView?.plainView.bounds.height) ?? 0)
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.categoryLabel.text = dropDownCategory[index]
        }
        
        dropDown.show()
    }
    
    @IBAction func dropDownDeliveryButton(_ sender: UIButton) {
        dropDown.anchorView = dropDownDeliveryView
        dropDown.dataSource = dropDownDelivery
        

        dropDownSize(byX: 200, byY: (dropDown.anchorView?.plainView.bounds.height) ?? 0)
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.deliveryLabel.text = dropDownDelivery[index]
        }
        
        dropDown.show()
    }
    
    // MARK: - Helper method
    
    func dropDownSize(byX x: CGFloat, byY y: CGFloat) {
        dropDown.bottomOffset = CGPoint(x: x, y: y)
        dropDown.topOffset = CGPoint(x: x, y: y)
        dropDown.direction = .bottom

    }
}
