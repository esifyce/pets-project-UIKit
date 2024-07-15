//
//  MainViewModel.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import RxSwift
import RxCocoa

protocol IMainViewModel {
    func transform(_ input: MainViewModel.Input) -> MainViewModel.Output
}

struct MainViewModel: IMainViewModel {
    
    let navigator: IMainNavigator
    let articlesUseCase: IArticlesUseCase
    let articlesCacheUseCase: IArticlesCacheUseCase
    
    func transform(_ input: Input) -> Output {
        let initialLogic = input.viewWillAppear.flatMapLatest {
            articlesUseCase.getArticle(with: "pet")
                .asSignal(onErrorSignalWith: .empty())
                .do(onNext: articlesCacheUseCase.setArticles)
        }.voidType()
        let articles = articlesCacheUseCase.articles().map { articles in
            articles.map { model in
                MainSection.Cell.content(
                    MainSection.Article(
                        model: model,
                        tap: Transformer<Void, Void> {
                            $0.do(
                                onNext: {
                                    navigator.showArticleDetail(with: model)
                                }
                            )
                        }
                    )
                )
            }
        }.map { [MainSection(identity: "base", items: $0)] }
        .asDriver(onErrorDriveWith: .empty())
        
        return .init(
            articleSections: articles,
            logic: .merge(
                initialLogic
            )
        )
    }
}

extension MainViewModel {
    struct Input {
        let viewWillAppear: Signal<Void>
    }
    struct Output {
        let articleSections: Driver<[MainSection]>
        let logic: Signal<Void>
    }
}
