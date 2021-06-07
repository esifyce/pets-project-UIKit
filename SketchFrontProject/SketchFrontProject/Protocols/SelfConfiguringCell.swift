//
//  SelfConfiguringCell.swift
//  SketchFrontProject
//
//  Created by Sabir Myrzaev on 07.06.2021.
//

import UIKit

protocol SelfConfiguringCell {
    static var reuseId: String { get }
    func configure(with user: ContactsModel.User)
}
