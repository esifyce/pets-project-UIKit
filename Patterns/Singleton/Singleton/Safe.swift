//
//  Safe.swift
//  Singleton
//
//  Created by Sabir Myrzaev on 18.06.2021.
//

import Foundation

class Safe {
    
    var money = 0
    static let shared = Safe()
    
    private init() { }
}
