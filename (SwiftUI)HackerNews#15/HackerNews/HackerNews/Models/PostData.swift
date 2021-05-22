//
//  PostData.swift
//  HackerNews
//
//  Created by Sabir Myrzaev on 22.05.2021.
//  Copyright © 2021 Sabir. All rights reserved.
//

import Foundation

struct Results: Decodable {
    let hits: [Post]
}

struct Post: Decodable, Identifiable {
    var id: String {
        return objectID
    }
    let objectID: String
    let points: Int
    let title: String
    let url: String?
}
