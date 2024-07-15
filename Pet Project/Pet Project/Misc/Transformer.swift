//
//  Transformer.swift
//  Pet Project
//
//  Created by Sultan on 30/12/22.
//

import RxCocoa
import RxSwift

struct Transformer<In, Out>: Equatable {
    let identifier: String
    let transformer: (Signal<In>) -> Signal<Out>

    init(
        identifier: String = UUID().uuidString,
        transformer: @escaping (Signal<In>) -> Signal<Out>
    ) {
        self.identifier = identifier
        self.transformer = transformer
    }

    func transform(_ input: Signal<In>) -> Signal<Out> {
        transformer(input)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.identifier == rhs.identifier
    }
}
