//
//  DetailViewModel.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import RxCocoa

protocol IDetailViewModel {
    func transform(_ input: DetailViewModel.Input) -> DetailViewModel.Output
}

struct DetailViewModel: IDetailViewModel {
    
    let navigator: IDetailNavigator
    let model: ArticleModel
    
    func transform(_ input: Input) -> Output {
        let data = input.viewWillAppear.mapTo(model).asDriver(onErrorDriveWith: .empty())
        return .init(
            title: data.compactMap(\.title),
            author: data.compactMap(\.author),
            content: data.compactMap(\.content),
            imageURL: data.compactMap(\.urlToImage).compactMap { URL(string: $0) },
            logic: .empty()
        )
    }
}

extension DetailViewModel {
    struct Input {
        let viewWillAppear: Signal<Void>
    }
    struct Output {
        let title: Driver<String>
        let author: Driver<String>
        let content: Driver<String>
        let imageURL: Driver<URL>
        let logic: Signal<()>
    }
}
