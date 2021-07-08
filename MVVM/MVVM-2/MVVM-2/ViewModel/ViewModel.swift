//
//  ViewModel.swift
//  MVVM-2
//
//  Created by Sabir Myrzaev on 08.07.2021.
//

import Foundation

class ViewModel: TableViewViewModelType {

    private var selectedIndexPath: IndexPath?
    
     var profiles = [
            Profile(name: "John", secondName: "Smith", age: 33),
            Profile(name: "Mark", secondName: "Salmon", age: 56),
            Profile(name: "Sak", secondName: "Kolbi", age: 21)
    ]
    
    func numberOfRows() -> Int {
        return profiles.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableViewCellViewModelType? {
        let profile = profiles[indexPath.row]
        return TableViewCellViewModel(profile: profile)
    }
    
    func viewModelForSelectedRow() -> DetailViewModelType? {
        guard let selectedIndexPath = selectedIndexPath else { return nil }
        return DetailViewModel(profile: profiles[selectedIndexPath.row])
    }
    
    func selectROw(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
}
