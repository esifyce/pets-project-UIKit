//
//  SharedSequence+Extensions.swift
//  Pet Project
//
//  Created by Sultan on 30/12/22.
//

import RxCocoa

extension SharedSequenceConvertibleType {
    func voidType() -> SharedSequence<SharingStrategy, Void> { map { _ in } }
}

