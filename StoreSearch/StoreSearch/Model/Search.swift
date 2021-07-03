//
//  Search.swift
//  StoreSearch
//
//  Created by Sabir Myrzaev on 02.07.2021.
//

import Foundation

typealias SearchComplete = (Bool) -> Void

class Search {

    enum State {
        case notSearchedYet
        case loading
        case noResults
        case results([SearchResult])
    }
    
    enum Category: Int {
        case all = 0
        case music = 1
        case software = 2
        case ebooks = 3
        
        var type: String {
            switch self {
            case .all: return ""
            case .music: return "musicTrack"
            case .software: return "software"
            case .ebooks: return "ebook"
            }
        }
    }
    
    // отслеживает Search текущее состояние
    private(set) var state: State = .notSearchedYet
    private var dataTask: URLSessionDataTask?
    
    // MARK: - Helper methods
    
    func performSearch(for text: String, category: Category, completion: @escaping SearchComplete) {
        
        if !text.isEmpty {
            dataTask?.cancel()
            state = .loading
            
            // 1. Создайте URLобъект, используя поисковый текст
            let url = iTunesURL(searchText: text, category: category)
            // 2. Получите общий URLSession экземпляр
            let session = URLSession.shared
            // 3. Используем сеть
            dataTask = session.dataTask(with: url) { data, response, error in
                var success = false
                var newState = State.notSearchedYet

                // 4. Создаем задачу с данными
                print("On main thread?" + (Thread.current.isMainThread ? "Yes" : "No"))
                if let error = error as NSError?, error.code == -999 {
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                        var searchResults = self.parse(data: data)
                        if searchResults.isEmpty {
                            newState = .noResults
                        } else {
                            searchResults.sort(by: <)
                            newState = .results(searchResults)
                        }
                        success = true
                    }
                    DispatchQueue.main.async {
                        self.state = newState
                        completion(success)
                    }
                }
                // 5. отправляет запрос на сервер в фоновом потоке
                self.dataTask?.resume()
            }
        }
    
    private func iTunesURL(searchText: String, category: Category) -> URL {
        
        let locale = Locale.autoupdatingCurrent
        let language = locale.identifier
        let countryCode = locale.regionCode ?? "en_US"
        
        let kind = category.type
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = "https://itunes.apple.com/search?" +
                        "term=\(encodedText)&limit=200&entity=\(kind)" +
                        "&lang=\(language)&country=\(countryCode)"
        let url = URL(string: urlString)
        print(url!)
        return url!
    }
    
    
    private func parse(data: Data) -> [SearchResult] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultArray.self, from: data)
            return result.results
        } catch {
            print("Error JSON: \(error)")
            return []
        }
    }
}
