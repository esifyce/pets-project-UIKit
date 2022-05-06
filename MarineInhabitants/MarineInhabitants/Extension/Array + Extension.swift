//
//  Array + Extension.swift
//  MarineInhabitants
//
//  Created by Sabir Myrzaev on 2/5/22.
//

import Foundation

extension Array
{
    mutating func move(from oldIndex: Index, to newIndex: Index) {
        if oldIndex == newIndex { return }
        if abs(newIndex - oldIndex) == 1 { return self.swapAt(oldIndex, newIndex) }
        self.insert(self.remove(at: oldIndex), at: newIndex)
    }
}
