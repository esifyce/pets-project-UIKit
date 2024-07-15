//
//  RealmMigrator.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import RealmSwift
import Swinject

extension Dependency {
    static func registerRealmMigrator(with container: Container) {
        container.register(IRealmMigrator.self) { resolver in
            RealmMigrator(directoryUrl: resolver.resolve(URL.self, name: DependencyNames.databaseDirectory.rawValue)!)
        }
    }
}

protocol IRealmMigrator {
    func getRealm() -> Realm
    func getRealmQueue() -> DispatchQueue
}

fileprivate struct RealmMigrator: IRealmMigrator {
    private static let schemaVersion: UInt64 = 1
    private static let realmQueue = DispatchQueue(label: "realmQueue", qos: .userInteractive)
    
    let directoryUrl: URL
    
    func getRealm() -> Realm {
        let configuration = configuration(directoryUrl: directoryUrl)
        if let realm = getRealmQueue().sync(execute: { try? Realm(configuration: configuration, queue: getRealmQueue()) }) {
            return realm
        }
        try? FileManager.default.createDirectory(at: directoryUrl, withIntermediateDirectories: true)
        try? FileManager.default.contentsOfDirectory(atPath: directoryUrl.path).forEach {
            try? FileManager.default.removeItem(atPath: directoryUrl.appendingPathComponent($0).path)
        }
        return getRealmQueue().sync {
            try! Realm(configuration: configuration, queue: getRealmQueue())
        }
    }
    
    func getRealmQueue() -> DispatchQueue {
        return RealmMigrator.realmQueue
    }
    
    private func configuration(directoryUrl: URL) -> Realm.Configuration {
        .init(
            fileURL: directoryUrl.appendingPathComponent("default.realm"),
            readOnly: false,
            schemaVersion: RealmMigrator.schemaVersion,
            migrationBlock: { migration, oldSchemaVersion in

            }
        )
    }
}
