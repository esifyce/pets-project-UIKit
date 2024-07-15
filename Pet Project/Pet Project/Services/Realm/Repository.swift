//
//  Repository.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import Foundation
import RxRealm
import RxSwift
import RealmSwift

typealias IObject = Object & Codable

struct Repository<Model: IObject, Target: Codable> {
    let realm: Realm
    let realmQueue: DispatchQueue
    let returnQueue: DispatchQueue
    let encoder: JSONEncoder
    let decoder: JSONDecoder
    
    var realmScheduler: SchedulerType {
        ConcurrentDispatchQueueScheduler(queue: realmQueue)
    }
    
    var returnScheduler: SchedulerType {
        SerialDispatchQueueScheduler(queue: returnQueue, internalSerialQueueName: "ru.pet-project.repository")
    }
    
    init(
        realm: Realm,
        realmQueue: DispatchQueue,
        returnQueue: DispatchQueue = .main,
        encoder: JSONEncoder = .init(),
        decoder: JSONDecoder = .init()
    ) {
        self.realm = realm
        self.realmQueue = realmQueue
        self.returnQueue = returnQueue
        self.encoder = encoder
        self.decoder = decoder
    }
    
    var singleObject: Observable<Target?> {
        realmQueue.sync {
            Observable
                .collection(from: realm.objects(Model.self), on: realmQueue)
                .subscribe(on: realmScheduler)
                .observe(on: realmScheduler)
                .flatMapLatest {
                    if $0.isEmpty {
                        return Observable<Model?>.just(nil)
                    } else {
                        return Observable.from(object: $0.last!).map {
                            $0 as Model?
                        }.catchAndReturn(nil)
                    }
                }.recode(encoder: encoder, decoder: decoder)
        }.observe(on: returnScheduler)
    }
    
    func getSingleObject() throws -> Target? {
        try realmQueue.sync {
            try realm.objects(Model.self).last?.recode(encoder: encoder, decoder: decoder)
        }
    }
    
    func setSingleObject(_ object: Target?) throws {
        try realmQueue.sync {
            try realm.writeOpeningTransactionIfNeeded {
                let object: Model? = try object?.recode(encoder: encoder, decoder: decoder)
                if let primaryKey = Model.primaryKey() {
                    if let primaryKeyValue = object?.value(forKey: primaryKey) {
                        realm.delete(realm.objects(Model.self)
                            .filter("\(primaryKey) != \(primaryKeyValue)"))
                    } else {
                        realm.delete(realm.objects(Model.self))
                    }
                    if let object = object {
                        realm.add(object, update: .modified)
                    }
                } else {
                    realm.delete(realm.objects(Model.self))
                    if let object = object {
                        realm.add(object, update: .error)
                    }
                }
            }
        }
    }
    
    func objects(
        _ sorter: (keypath: String, ascending: Bool)? = nil,
        predicate: NSPredicate? = nil
    ) -> Observable<Array<Target>> {
        realmQueue.sync {
            Observable
                .collection(from: _getObjects(sorter, predicate: predicate), on: realmQueue)
                .subscribe(on: realmScheduler)
                .observe(on: realmScheduler)
                .recode(encoder: encoder, decoder: decoder)
        }.observe(on: returnScheduler)
    }
    
    func getObjects(
        _ sorter: (keypath: String, ascending: Bool)? = nil,
        predicate: NSPredicate? = nil
    ) throws -> Array<Target> {
        try realmQueue.sync {
            try _getObjects(sorter, predicate: predicate).recode(encoder: encoder, decoder: decoder)
        }
    }
    
    func addObjects(_ objects: [Target]) throws {
        try realmQueue.sync {
            try realm.writeOpeningTransactionIfNeeded {
                realm.add(
                    try objects.recode(encoder: encoder, decoder: decoder) as [Model],
                    update: Model.primaryKey() != nil ? .all : .error
                )
            }
        }
    }

    func setObjects(_ objects: [Target]) throws {
        try realmQueue.sync {
            try realm.writeOpeningTransactionIfNeeded {
                realm.delete(realm.objects(Model.self))
                realm.add(
                    try objects.recode(encoder: encoder, decoder: decoder) as [Model],
                    update: Model.primaryKey() != nil ? .all : .error
                )
            }
        }
    }
    
    func object<KeyType>(for primaryKey: KeyType) -> Observable<Target?> {
        realmQueue.sync {
            Observable
                .collection(
                    from: realm.objects(Model.self).filter("%K == %@", Model.primaryKey()!, primaryKey),
                    on: realmQueue
                ).subscribe(on: realmScheduler)
                .observe(on: realmScheduler)
                .flatMapLatest {
                    if $0.isEmpty {
                        return Observable<Model?>.just(nil)
                    } else {
                        return Observable.from(object: $0.first!).map {
                            $0 as Model?
                        }.catch { _ in
                            return .just(nil)
                        }
                    }
                }.recode(encoder: encoder, decoder: decoder)
        }.observe(on: returnScheduler)
    }

    func object<KeyType>(for primaryKey: KeyType) throws -> Target? {
        try realmQueue.sync {
            try realm.object(
                ofType: Model.self,
                forPrimaryKey: primaryKey
            )?.recode(encoder: encoder, decoder: decoder)
        }
    }
    
    func changeSet(_ predicate: NSPredicate? = nil) -> Observable<(AnyRealmCollection<Model>, RealmChangeset?)> {
        realmQueue.sync { () -> Observable<(AnyRealmCollection<Model>, RealmChangeset?)> in
            if let predicate = predicate {
                return Observable.changeset(
                    from: realm.objects(Model.self).filter(predicate),
                    on: realmQueue
                ).subscribe(on: realmScheduler)
                .observe(on: realmScheduler)
            } else {
                return Observable.changeset(
                    from: realm.objects(Model.self),
                    on: realmQueue
                ).subscribe(on: realmScheduler)
                .observe(on: realmScheduler)
            }
        }.observe(on: returnScheduler)
    }
}

fileprivate extension Repository {

    func _getObjects(_ sorter: (keypath: String, ascending: Bool)? = nil, predicate: NSPredicate? = nil) -> Results<Model> {
        var objects = realm.objects(Model.self)
        if let sorter = sorter {
            objects = objects.sorted(byKeyPath: sorter.keypath, ascending: sorter.ascending)
        }
        if let predicate = predicate {
            objects = objects.filter(predicate)
        }
        return objects
    }
}


fileprivate extension Realm {
    func writeOpeningTransactionIfNeeded(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}


private extension ObservableType where Element: Encodable {
    func recode<Model: Decodable>(
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) -> Observable<Model> {
        flatMap {
            Observable.just(try $0.recode(encoder: encoder, decoder: decoder) as Model)
        }
    }
}

private extension Encodable {
    func recode<Model: Decodable>(
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) throws -> Model {
        let data = try encoder.encode(self)
        return try decoder.decode(Model.self, from: data)
    }
}
