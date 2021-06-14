//
//  ChecklistData.swift
//  Checklist
//
//  Created by Sabir Myrzaev on 14.06.2021.
//

import UIKit

class ChecklistData: NSObject, Codable {
    var name = ""
    var iconName = "No Icon"
    var items = [ChecklistItem]()
    
    init(name: String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    // подсчитать предметы в списке
//    func countUncheckedItems() -> Int {
//        var count = 0
//        for item in items where !item.checked {
//            count += 1
//        }
//        return count
//    }
//
    // как бы выглядел метов в функциональном программировании
    // reduce()- это метод, который просматривает каждый элемент в массиве
    func countUncheckedItems() -> Int {
        return items.reduce(0) {
            cnt, item in cnt + (item.checked ? 0 : 1)
        }
    }
}
