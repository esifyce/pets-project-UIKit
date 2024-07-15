//
//  ArticlesCacheUseCase.swift
//  Pet Project
//
//  Created by Sultan on 30/12/22.
//

import RxSwift
import RealmSwift
import Swinject

extension Dependency {
    static func registerArticleCacheUseCase(with container: Container) {
        container.register(IArticlesCacheUseCase.self) { resolver in
            let realmMigrator = resolver.resolve(IRealmMigrator.self)!
            return ArticlesCacheUseCase(realm: realmMigrator.getRealm(), realmQueue: realmMigrator.getRealmQueue())
        }
    }
}

protocol IArticlesCacheUseCase {
    func articles() -> Observable<[ArticleModel]>
    func setArticles(with articles: [ArticleModel])
    func getArticles() -> [ArticleModel]
}

private struct ArticlesCacheUseCase: IArticlesCacheUseCase {
    let repository: Repository<ArticleObject, ArticleModel>
    
    init(realm: Realm, realmQueue: DispatchQueue) {
        repository = .init(realm: realm, realmQueue: realmQueue)
    }
    
    func articles() -> Observable<[ArticleModel]> {
        repository.objects()
    }
    
    func setArticles(with articles: [ArticleModel]) {
        try? repository.setObjects(articles)
    }
    
    func getArticles() -> [ArticleModel] {
        (try? repository.getObjects()) ?? []
    }
}
