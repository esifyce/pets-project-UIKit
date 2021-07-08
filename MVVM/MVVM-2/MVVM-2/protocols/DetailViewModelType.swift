//
//  DetailViewModelType.swift
//  MVVM-2
//
//  Created by Sabir Myrzaev on 08.07.2021.
//

import Foundation

protocol DetailViewModelType {
    var description: String { get }
    var age: Box<String?> { get }
}
