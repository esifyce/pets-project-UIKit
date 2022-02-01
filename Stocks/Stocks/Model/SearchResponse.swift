//
//  SearchResponse.swift
//  Stocks
//
//  Created by Sabir Myrzaev on 25.11.2021.
//

import Foundation

struct SearchResponse: Codable {
    let count: Int
    let result: [SearchResult]
}

struct SearchResult: Codable {
    let description: String
    let displaySymbol: String
    let symbol: String
    let type: String
}
