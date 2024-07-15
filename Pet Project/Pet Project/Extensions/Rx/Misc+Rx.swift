//
//  Misc+Rx.swift
//  Pet Project
//
//  Created by Sultan on 30/12/22.
//

import RxDataSources

extension AnimationConfiguration {
    static var fade: AnimationConfiguration {
        .init(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .fade)
    }
}

extension IdentifiableType where Self: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.identity == rhs.identity
    }
}
