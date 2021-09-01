//
//  GPPersistenceRequest.swift
//  CryptoTrackerStorage
//
//  Created by Trick Gorospe on 9/1/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import Foundation

public struct SortDescriptor {
    public let keyPath: String
    public let ascending: Bool

    public init(keyPath: String, ascending: Bool = false) {
        self.keyPath = keyPath
        self.ascending = ascending
    }
}

public protocol GPPersistenceRequest {
    var predicate: NSPredicate { get }
    var sortDescriptors: [SortDescriptor] { get }
}
