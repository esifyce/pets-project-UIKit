//
//  NetworkWeatherManager.swift
//  WeatherApp
//
//  Created by Sabir Myrzaev on 04.06.2021.
//

import Foundation
import CoreLocation
//protocol NetworkWeatherManagerDelegate: AnyObject {
//    func updateInterface(_: NetworkWeatherManager, with weatherModel: WeatherModel)
//}

class NetworkWeatherManager {
    
    enum  RequestType {
        case cityName(city: String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
  //  weak var delegate: NetworkWeatherManagerDelegate?
        // через клоужеры
     var onCompletion: ((WeatherModel) -> Void)?
    
    func fetchData(forRequestType requestType: RequestType) {
        var urlString = ""
        switch requestType {
        case .cityName(let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        case .coordinate(let latitude, let longitude):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        }
        perfomRequest(withURLString: urlString)
    }
    
    fileprivate func perfomRequest(withURLString urlString: String) {
        guard let url = URL(string: urlString) else { return }
        // создаем сессию
        let session = URLSession(configuration: .default)
        // сетевой запрос
        let task = session.dataTask(with: url) { data, response, error in
            // проверка действительно ли данные есть
            if let data = data {
                // отражает json в консоли
//                let dataString = String(data: data, encoding: .utf8)
//                print(dataString!)
                
                // через делегаты
//                if let weatherModel = self.parseJSON(withData: data) {
//                    self.delegate?.updateInterface(self, with: weatherModel)
//                }
                
                // через клоужеры
                if let weatherModel = self.parseJSON(withData: data) {
                    self.onCompletion?(weatherModel)
                }
            }
        }
        // работа сетевого запроса
        task.resume()
}
    
    
    
    // раскладывает JSON по WeatherModelData
    fileprivate func parseJSON(withData data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
        let weatherModelData = try decoder.decode(WeatherModelData.self, from: data)
            guard let weatherModel = WeatherModel(weatherModelData: weatherModelData) else { return nil }
            return weatherModel
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
