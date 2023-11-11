//
//  GraphModelManager.swift
//  EncryptDemidLab1
//
//  Created by Krasivo on 11.11.2023.
//

import Foundation

final class GraphModelManager {
    static let shared = GraphModelManager()

    private let userDefaults = UserDefaults.standard
    private let monoKey = "mono.graphModel"
    private let cesuarKey = "cesuar.graphModel"
    private let tritemiusKey = "tritemius.graphModel"
    
    func clearMemory() {
        userDefaults.removeObject(forKey: monoKey)
        userDefaults.removeObject(forKey: cesuarKey)
        userDefaults.removeObject(forKey: tritemiusKey)
        userDefaults.synchronize()
    }

    func saveMonoGraphModel(_ graphModel: GraphModel) {
        userDefaults.removeObject(forKey: monoKey)
        if let encodedData = try? JSONEncoder().encode(graphModel) {
            userDefaults.set(encodedData, forKey: monoKey)
        }
        userDefaults.synchronize()
    }
    
    func saveCesuarGraphModel(_ graphModel: GraphModel) {
        userDefaults.removeObject(forKey: cesuarKey)
        if let encodedData = try? JSONEncoder().encode(graphModel) {
            userDefaults.set(encodedData, forKey: cesuarKey)
        }
        userDefaults.synchronize()
    }
    
    func saveTritemiusGraphModel(_ graphModel: GraphModel) {
        userDefaults.removeObject(forKey: tritemiusKey)
        if let encodedData = try? JSONEncoder().encode(graphModel) {
            userDefaults.set(encodedData, forKey: tritemiusKey)
        }
        userDefaults.synchronize()
    }

    func obtainMonoGraphModel() -> GraphModel? {
        if let savedData = userDefaults.data(forKey: monoKey) {
            if let graphModel = try? JSONDecoder().decode(GraphModel.self, from: savedData) {
                return graphModel
            }
        }
        return nil
    }

    func obtainCesuarGraphModel() -> GraphModel? {
        if let savedData = userDefaults.data(forKey: cesuarKey) {
            if let graphModel = try? JSONDecoder().decode(GraphModel.self, from: savedData) {
                return graphModel
            }
        }
        return nil
    }
    
    func obtainTritemiusGraphModel() -> GraphModel? {
        if let savedData = userDefaults.data(forKey: tritemiusKey) {
            if let graphModel = try? JSONDecoder().decode(GraphModel.self, from: savedData) {
                return graphModel
            }
        }
        return nil
    }
}
