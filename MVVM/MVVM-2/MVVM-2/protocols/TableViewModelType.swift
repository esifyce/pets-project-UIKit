//
//  TableViewModelType.swift
//  MVVM-2
//
//  Created by Sabir Myrzaev on 08.07.2021.
//

import Foundation

protocol TableViewViewModelType: AnyObject {
    func numberOfRows() -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableViewCellViewModelType?
    
    func viewModelForSelectedRow() -> DetailViewModelType?
    func selectROw(atIndexPath indexPath: IndexPath)
}
