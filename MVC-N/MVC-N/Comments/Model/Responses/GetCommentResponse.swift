//
//  getCommentResponse.swift
//  MVC-N
//
//  Created by Sabir Myrzaev on 18.06.2021.
//

import Foundation

// заполняем массив комментариев
struct GetCommentResponse {
    typealias JSON = [String: AnyObject]
    
    let comments: [Comment]
    
    init(json: Any) throws {
        guard let array = json as? [JSON] else { throw NetworkError.failInternetError }
        
        var comments = [Comment]()
        for dictionary in array {
            guard let comment = Comment(dict: dictionary) else { continue }
            comments.append(comment)
        }
        self.comments = comments
    }
}
