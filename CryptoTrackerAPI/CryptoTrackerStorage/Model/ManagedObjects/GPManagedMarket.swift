//
//  GPManagedMarket.swift
//  CryptoTrackerStorage
//
//  Created by Trick Gorospe on 8/30/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import Foundation
import RealmSwift

public class GPManagedMarket: Object {
    public typealias PlainObjectType = GPMarket
    
    @Persisted var id: String = ""
    @Persisted var symbol: String = ""
    @Persisted var name: String = ""
    @Persisted var image: String = ""
    @Persisted var currentPrice: Double = 0
    @Persisted var marketCap: Double = 0
    @Persisted var marketCapRank: Int = 0
    @Persisted var totalVolume: Double = 0
    @Persisted var high24h: Double = 0
    @Persisted var low24h: Double = 0
    @Persisted var priceChange24h: Double = 0
    @Persisted var priceChangePercentage24h: Double = 0
    @Persisted var circulatingSupply: Double = 0
    @Persisted var totalSupply: Double = 0
    @Persisted var allTimeHigh: Double = 0
    @Persisted var allTimeHighDate: Date? = nil
    @Persisted var lastUpdated: Date? = nil
    @Persisted var priceChangeIn1h: Double = 0
    @Persisted var priceChangeIn1y: Double = 0
    @Persisted var priceChangeIn24h: Double = 0
    @Persisted var priceChangeIn30d: Double = 0
    @Persisted var priceChangeIn7d: Double = 0
    
    public override static func primaryKey() -> String {
        return "id"
    }
    
    public required convenience init(plain object: PlainObjectType) {
        self.init()
       
    }
}

extension GPManagedMarket: PlainObjectTransformable {
    public var plainObject: PlainObjectType {
        return GPMarket(managed: self)
    }
}
