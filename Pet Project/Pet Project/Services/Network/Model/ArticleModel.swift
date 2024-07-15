//
//  ArticleModel.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import Foundation

struct ArticleRequestModel: Codable {
    let status: String
    let articles: [ArticleModel]
}

struct ArticleModel: Codable {
    let source: SourceModel?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct SourceModel: Codable {
    let id: String?
    let name: String?
}
