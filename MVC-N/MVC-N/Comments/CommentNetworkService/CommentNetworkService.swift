//
//  CommentNetworkService.swift
//  MVC-N
//
//  Created by Sabir Myrzaev on 18.06.2021.
//

import Foundation

class CommentNetworkService {
    private init() {}
    
    // получаем наши комментарии назад
    static func getComment(completion: @escaping(GetCommentResponse) -> ()) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1/comments") else { return }
        
        // получаем данные по адрессу
        NetworkService.shared.getData(url: url) { json in
            do {
                let response = try GetCommentResponse(json: json)
                completion(response)
            } catch {
                print(error)
            }
        }
    }
}
