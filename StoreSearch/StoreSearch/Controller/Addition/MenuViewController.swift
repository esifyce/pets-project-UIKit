//
//  MenuViewController.swift
//  StoreSearch
//
//  Created by Sabir Myrzaev on 03.07.2021.
//

import UIKit

protocol MenuViewControllerDelegate: AnyObject {
    func menuViewControllerSendEmail(_ controller: MenuViewController)
}

class MenuViewController: UITableViewController {

    weak var delegate: MenuViewControllerDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    // MARK: - delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            delegate?.menuViewControllerSendEmail(self)
        }
    }

}
