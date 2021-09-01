//
//  GPDatabaseService.swift
//  CryptoTrackerStorage
//
//  Created by Trick Gorospe on 8/30/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import Foundation
import Combine
import RealmSwift

public enum GPPersistenceError: Error {
    case emptyArray
    case noPrimaryKeyInClass
    case noPrimaryKeyValue
}

public protocol GPPersistenceServiceType {
    func save<T: ManagedObjectTransformable>(object: T) -> AnyPublisher<Void, Never>
    func save<T: ManagedObjectTransformable>(objects: [T]) -> AnyPublisher<Void, Never>
    func get<T: ManagedObjectTransformable>(at request: GPPersistenceRequest) -> AnyPublisher<[T], Never>
    func delete<T: ManagedObjectTransformable>(object: T) -> AnyPublisher<Void, Never>
    func delete<T: ManagedObjectTransformable>(objects: [T]) -> AnyPublisher<Void, Never>
}

public class GPPersistenceService: GPPersistenceServiceType {
    
    private let config: Realm.Configuration
    private let realmScheduler: DispatchQueue = .init(
        label: "com.patrick.CryptoTrackerStorage-Realm",
        qos: .default
    )
    
    public init(configuration: Realm.Configuration) {
        config = configuration
    }
    
    public func save<T>(object: T) -> AnyPublisher<Void, Never> where T : ManagedObjectTransformable {
        return save(objects: [object])
    }

    public func save<T>(objects: [T]) -> AnyPublisher<Void, Never> where T : ManagedObjectTransformable {
        return Future {  [config, realmScheduler] promise in
            realmScheduler.async {
                do {
                    let realm = try Realm(configuration: config)
                    try realm.safeWrite {
                        let managedObjects = objects.map { $0.managedObject }
                        realm.add(managedObjects, update: .modified)
                        promise(.success(()))
                    }
                }
                catch let error {
                    print(error)
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
//    public func save<T>(objects: [T]) -> AnyPublisher<Void, Never> where T : ManagedObjectTransformable {
//        return Just<()>(())
//            .receive(on: realmScheduler)
//            .map { [config] _ -> Realm in
//                return try! Realm(configuration: config)
//            }
//            .map { realm in
//                do {
//                    try realm.safeWrite {
//                        let managedObjects = objects.map { $0.managedObject }
//                        realm.add(managedObjects, update: .modified)
//                    }
//                } catch let error {
//                    print(error)
//                    return ()
//                }
//
//                return ()
//            }.eraseToAnyPublisher()
//    }

    public func get<T>(at request: GPPersistenceRequest) -> AnyPublisher<[T], Never> where T : ManagedObjectTransformable {
        return Just<()>(())
            .receive(on: realmScheduler)
            .map { [config] in try! Realm(configuration: config) }
            .map { $0.apply(request: request, to: T.ManagedObjectType.self) }
            .map { Array($0).map { $0.plainObject } }
            .eraseToAnyPublisher()
            
    }

    public func delete<T>(object: T) -> AnyPublisher<Void, Never> where T : ManagedObjectTransformable {
        return delete(objects: [object])
    }

    public func delete<T>(objects: [T]) -> AnyPublisher<Void, Never> where T : ManagedObjectTransformable {
        return Just<()>(())
            .receive(on: realmScheduler)
            .map({ [config] _ -> Realm in
                return try! Realm(configuration: config)
            }).flatMap({ realm -> Just<()> in
                guard let primaryKey = T.ManagedObjectType.primaryKey() else {
                    return Just<()>(())
                }
                let primaryKeyValues = objects.compactMap { $0.managedObject.value(forKey: primaryKey) }
                let predicate = NSPredicate(format: "\(primaryKey) IN %@", primaryKeyValues)
                do {
                    try realm.safeWrite {
                        let objectsToDrop = realm.objects(T.ManagedObjectType.self).filter(predicate)
                        realm.delete(objectsToDrop)
                    }
                    
                } catch { return Just<()>(()) }
            
                return Just<()>(())
            }).eraseToAnyPublisher()
    }

}

extension Realm {
    func safeWrite(_ block: () throws -> Void) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
    
    func apply<T: Object>(request: GPPersistenceRequest, to type: T.Type) -> Results<T> {
        return objects(T.self)
            .filter(request.predicate)
            .sorted(by: request.sortDescriptors.realmDescriptors)
    }
}

extension Array where Element == SortDescriptor {
    var realmDescriptors: [RealmSwift.SortDescriptor] {
        return map { RealmSwift.SortDescriptor(keyPath: $0.keyPath, ascending: $0.ascending) }
    }
}
