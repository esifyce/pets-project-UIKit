//
//  WeatherManager.swift
//  Clima
//
//  Created by Sabir Myrzaev on 14.05.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherManager {
    let weatherManager =  "https://api.openweathermap.org/data/2.5/weather?appid=49b7b9bb2e2e903d59cec2ed1f7722de&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherManager)&q=\(cityName)"
        
        performRequest(with: urlString)

    }
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherManager)&lat=\(latitude)&lon=\(longitude)"
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // работа с сетями, подключение страницы json к приложению
        // 1. create URL
        
        if let url = URL(string: urlString) {
        // 2. create a URLSession
            let session = URLSession(configuration: .default)
        // 3. give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
            // выяснить ошибку, если есть распечатать
                    if error != nil{
                        self.delegate?.didFailWithError(error: error!)
                            return
                }
                                                      
            if let safeData = data {
                // ввыводит все из json
              //  let dataString = String(data: safeData, encoding: .utf8)
             if let weather = self.parseJSON(safeData) {
                self.delegate?.didUpdateWeather(self,weather: weather)
        }
    }
}
        // 4. Start the task
            task.resume()
        }
    }

    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodedData.name
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            
            let weather = WeatherModel(conditioinID: id, cityName: name, temperature: temp)
            return weather
        }
        catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    
    }
    
}

