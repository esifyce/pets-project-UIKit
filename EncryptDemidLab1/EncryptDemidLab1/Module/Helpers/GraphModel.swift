//
//  GraphModel.swift
//  EncryptDemidLab1
//
//  Created by Krasivo on 11.11.2023.
//

import Foundation

struct GraphModel: Codable {
    let graphType: String
    var frequencyResult: [FrequencyModel]
    
    init(graphType: String, frequencyResult: [FrequencyModel]) {
        self.graphType = graphType
        self.frequencyResult = frequencyResult
    }
}

struct FrequencyModel: Codable {
    let char: String
    let count: Int
    let percentage: Double
}
