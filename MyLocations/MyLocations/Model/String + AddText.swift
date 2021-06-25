//
//  String + AddText.swift
//  MyLocations
//
//  Created by Sabir Myrzaev on 22.06.2021.
//

import Foundation

extension String {
    mutating func add(text: String?, separatorFor separator: String = "") {
        if let text = text {
            if !isEmpty {
                self += separator
            }
            self += text
        }
    }
}
