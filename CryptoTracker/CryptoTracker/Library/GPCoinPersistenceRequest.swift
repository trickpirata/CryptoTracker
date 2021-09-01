//
//  GPCoinPersistenceRequest.swift
//  CryptoTracker
//
//  Created by Trick Gorospe on 9/1/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import Foundation
import CryptoTrackerStorage

struct GPCoinPersistenceRequest: GPPersistenceRequest {
    let predicate: NSPredicate
    let sortDescriptors: [SortDescriptor]

    init(
        predicate: NSPredicate,
        sortDescriptors: [SortDescriptor] = []
    ) {
        self.predicate = predicate
        self.sortDescriptors = sortDescriptors
    }

    static var allCoins: GPCoinPersistenceRequest {
        return GPCoinPersistenceRequest(predicate: NSPredicate(value: true))
    }

    static func particular(coin: GPCoin) -> GPCoinPersistenceRequest {
        let predicate = NSPredicate(format: "id == %@", coin.id)

        return GPCoinPersistenceRequest(predicate: predicate)
    }

    private static func sortBy(_ key: String, ascending: Bool = false) -> GPCoinPersistenceRequest {
        // We want to fetch all videos
        let predicate = NSPredicate(value: true)
        let sortDesciptor = SortDescriptor(keyPath: key, ascending: ascending)

        return GPCoinPersistenceRequest(predicate: predicate, sortDescriptors: [sortDesciptor])
    }
}
