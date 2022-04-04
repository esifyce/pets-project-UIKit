//
//  RestaurantDiffableDataSource.swift
//  FoodPin
//
//  Created by Sabir Myrzaev on 30/3/22.
//

import UIKit

enum Section {
    case all
}

class RestaurantDiffableDataSource: UITableViewDiffableDataSource<Section, Restaurant> {

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}
