//
//  MarketDataResponse.swift
//  Stocks
//
//  Created by Sabir Myrzaev on 01.02.2022.
//

import Foundation

struct MarketDataResponse: Codable {
    let open: [Double]
    let close: [Double]
    let high: [Double]
    let low: [Double]
    let status: String
    let timestamps: [TimeInterval]
    
    enum CodingKeys: String, CodingKey {
        case open = "o"
        case low = "l"
        case close = "c"
        case high = "h"
        case status = "s"
        case timestamps = "t"
    }
    var candleStrick: [CandleStick] {
        var result = [CandleStick]()
        
        for index in 0..<open.count {
            result.append(.init(date: Date(timeIntervalSince1970: timestamps[index]), high: high[index], low: low[index], open: open[index], close: close[index]))
        }
        let sorted = result.sorted(by: { $0.date > $1.date} )
        print(sorted[0])
        return result
    }
}

struct CandleStick {
    let date: Date
    let high: Double
    let low: Double
    let open: Double
    let close: Double
}
