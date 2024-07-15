//
//  MainSection.swift
//  Pet Project
//
//  Created by Sultan on 30/12/22.
//

import RxDataSources

struct MainSection: AnimatableSectionModelType {
    let identity: String
    let items: [Cell]
    
    enum Cell: IdentifiableType, Equatable {
        case content(Article)
        
        var identity: String {
            switch self {
            case .content(let article):
                return article.model.url ?? UUID().uuidString
            }
        }
    }
    
    struct Article {
        let model: ArticleModel
        let tap: Transformer<Void, Void>
    }
    
    init(identity: String, items: [Cell]) {
        self.identity = identity
        self.items = items
    }
    
    init(original: MainSection, items: [Cell]) {
        identity = original.identity
        self.items = items
    }
}
