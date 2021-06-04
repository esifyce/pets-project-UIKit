//
//  WeatherModelData.swift
//  WeatherApp
//
//  Created by Sabir Myrzaev on 04.06.2021.
//

import Foundation

struct WeatherModelData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    
    // меняет назавания ключа
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
    }
}

struct Weather: Codable {
    let id: Int
}
