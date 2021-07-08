//
//  NetworkManager.swift
//  MVVM-3
//
//  Created by Sabir Myrzaev on 08.07.2021.
//

import Foundation

class NetworkManager: NSObject {
    
    func fetchMovies(completion: ([String]) -> ()) {
        completion(["Movie 1", "Movie 2", "Movie 3"])
    }
}
