//
//  FinancialMetricsResponse.swift
//  Stocks
//
//  Created by Sabir Myrzaev on 01.02.2022.
//

import Foundation

struct FinancialMetricsResponse: Codable {
    let metric: Metrics
}

struct Metrics: Codable {
    let TenDayAverageTradingVolume: Float
    let AnnualWeekHigh: Double
    let AnnualWeekLow: Double
    let AnnualWeekLowDate: String
    let AnnualWeekPriceReturnDaily: Float
    let beta: Float
    
    enum CodingKeys: String, CodingKey {
       case TenDayAverageTradingVolume = "10DayAverageTradingVolume"
       case AnnualWeekHigh = "52WeekHigh"
       case AnnualWeekLow = "52WeekLow"
       case AnnualWeekLowDate = "52WeekLowDate"
       case AnnualWeekPriceReturnDaily = "52WeekPriceReturnDaily"
       case beta
    }
}

