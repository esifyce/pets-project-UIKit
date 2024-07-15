//
//  ArticlesUseCase.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import RxSwift
import Moya
import Swinject

extension Dependency {
    static func registerArticlesUseCase(with container: Container) {
        container.register(IArticlesUseCase.self) {
            ArticlesUseCase(tokenPlugin: $0.resolve(TokenPlugin.self)!)
        }
    }
}

protocol IArticlesUseCase {
    func getArticle(with search: String) -> Single<[ArticleModel]>
}

private struct ArticlesUseCase: IArticlesUseCase {
    
    let provider: ResultProvider<Router>
    
    init(tokenPlugin: TokenPlugin) {
        provider = ResultProvider<Router>(tokenPlugin: tokenPlugin)
    }
    
    func getArticle(with search: String) -> Single<[ArticleModel]> {
        provider.request(.getArticle(search: search), successModel: ArticleRequestModel.self)
            .map(\.articles)
    }
}

private enum Router: IBaseRouter, TargetType {
    case getArticle(search: String)
    
    var path: String {
        switch self {
        case .getArticle:
            return "v2/everything"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getArticle:
            return .get
        }
    }
    
    var task: Moya.Task {
        var parameters: [String: Any] = ["apiKey": "5130023139234fa1a39ce82f559d7b71"]
        switch self {
        case .getArticle(let search):
            parameters["q"] = search
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        }
    }
}
