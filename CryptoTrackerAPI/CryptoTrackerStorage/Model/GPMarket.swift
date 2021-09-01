//
//  GPMarket.swift
//  CryptoTrackerStorage
//
//  Created by Trick Gorospe on 8/30/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import Foundation

public class GPMarket: Codable {
    public let id: String
    public let symbol: String
    public let name: String
    public let image: String?
    public let currentPrice: Double
    public let marketCap: Double
    public let marketCapRank: Int
    public let totalVolume: Double
    public let high24h: Double
    public let low24h: Double
    public let priceChange24h: Double
    public let priceChangePercentage24h: Double
    public let circulatingSupply: Double
    public let totalSupply: Double
    public let allTimeHigh: Double
    public let allTimeHighDate: Date?
    public let lastUpdated: Date?
    public let priceChangeIn1h: Double?
    public let priceChangeIn1y: Double?
    public let priceChangeIn24h: Double?
    public let priceChangeIn30d: Double?
    public let priceChangeIn7d: Double?
    
    private enum Keys: String, CodingKey {
        case id
        case symbol
        case name
        case image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case totalVolume = "total_volume"
        case high24h = "high_24h"
        case low24h = "low_24h"
        case priceChange24h = "price_change_24h"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case allTimeHigh = "ath"
        case allTimeHighDate = "ath_date"
        case lastUpdated = "last_updated"
        case priceChangeIn1h = "price_change_percentage_1h_in_currency"
        case priceChangeIn1y = "price_change_percentage_1y_in_currency"
        case priceChangeIn24h = "price_change_percentage_24h_in_currency"
        case priceChangeIn30d = "price_change_percentage_30d_in_currency"
        case priceChangeIn7d = "price_change_percentage_7d_in_currency"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        id = try container.decode(String.self, forKey: .id)
        symbol = try container.decode(String.self, forKey: .symbol)
        name = try container.decode(String.self, forKey: .name)
        image = try container.decodeIfPresent(String.self, forKey: .image) ?? nil
        currentPrice = try container.decodeIfPresent(Double.self, forKey: .currentPrice) ?? 0
        marketCap = try container.decodeIfPresent(Double.self, forKey: .marketCap) ?? 0
        marketCapRank = try container.decodeIfPresent(Int.self, forKey: .marketCapRank) ?? 0
        totalVolume = try container.decodeIfPresent(Double.self, forKey: .totalVolume) ?? 0
        high24h = try container.decodeIfPresent(Double.self, forKey: .high24h) ?? 0
        low24h = try container.decodeIfPresent(Double.self, forKey: .low24h) ?? 0
        priceChange24h = try container.decodeIfPresent(Double.self, forKey: .priceChange24h) ?? 0
        priceChangePercentage24h = try container.decode(Double.self, forKey: .priceChangePercentage24h)
        circulatingSupply = try container.decodeIfPresent(Double.self, forKey: .circulatingSupply) ?? 0
        totalSupply = try container.decodeIfPresent(Double.self, forKey: .totalSupply) ?? .nan
        allTimeHigh = try container.decodeIfPresent(Double.self, forKey: .allTimeHigh) ?? 0
        let athDate = try container.decodeIfPresent(String.self, forKey: .allTimeHighDate)
        allTimeHighDate = dateFormatter.date(from: athDate ?? "")
        let lastUpdatedDate = try container.decodeIfPresent(String.self, forKey: .lastUpdated)
        lastUpdated = dateFormatter.date(from: lastUpdatedDate ?? "")
        priceChangeIn1h = try container.decodeIfPresent(Double.self, forKey: .priceChangeIn1h) ?? nil
        priceChangeIn1y = try container.decodeIfPresent(Double.self, forKey: .priceChangeIn1y) ?? nil
        priceChangeIn24h = try container.decodeIfPresent(Double.self, forKey: .priceChangeIn24h) ?? nil
        priceChangeIn30d = try container.decodeIfPresent(Double.self, forKey: .priceChangeIn30d) ?? nil
        priceChangeIn7d = try container.decodeIfPresent(Double.self, forKey: .priceChangeIn7d) ?? nil
    }
    
    public static var empty: GPMarket {
        return GPMarket(id: "")
    }
    
    init(id: String,
         symbol: String = "",
         name: String = "",
         image: String = "",
         currentPrice: Double = 0,
         marketCap: Double = 0,
         marketCapRank: Int = 0,
         totalVolume: Double = 0,
         high24h: Double = 0,
         low24h: Double = 0,
         priceChange24h: Double = 0,
         priceChangePercentage24h: Double = 0,
         circulatingSupply: Double = 0,
         totalSupply: Double = 0,
         allTimeHigh: Double = 0,
         allTimeHighDate: Date? = nil,
         lastUpdated: Date? = nil,
         priceChangeIn1h: Double? = nil,
         priceChangeIn1y: Double? = nil,
         priceChangeIn24h: Double? = nil,
         priceChangeIn30d: Double? = nil,
         priceChangeIn7d: Double? = nil) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.image = image
        self.currentPrice = currentPrice
        self.marketCap = marketCap
        self.marketCapRank = marketCapRank
        self.totalVolume = totalVolume
        self.high24h = high24h
        self.low24h = low24h
        self.priceChange24h = priceChange24h
        self.priceChangePercentage24h = priceChangePercentage24h
        self.circulatingSupply = circulatingSupply
        self.totalSupply = totalSupply
        self.allTimeHigh = allTimeHigh
        self.allTimeHighDate = allTimeHighDate
        self.lastUpdated = lastUpdated
        self.priceChangeIn1h = priceChangeIn1h
        self.priceChangeIn1y = priceChangeIn1y
        self.priceChangeIn24h = priceChangeIn24h
        self.priceChangeIn30d = priceChangeIn30d
        self.priceChangeIn7d = priceChangeIn7d
    }
    
    public required convenience init(managed object: ManagedObjectType) {
        self.init(id: object.id,
                 symbol: object.symbol,
                 name: object.name,
                 image: object.image,
                 currentPrice: object.currentPrice,
                 marketCap: object.marketCap,
                 marketCapRank: object.marketCapRank,
                 totalVolume: object.totalVolume,
                 high24h: object.high24h,
                 low24h: object.low24h,
                 priceChange24h: object.priceChange24h,
                 priceChangePercentage24h: object.priceChangePercentage24h,
                 circulatingSupply: object.circulatingSupply,
                 totalSupply: object.totalSupply,
                 allTimeHigh: object.allTimeHigh,
                 allTimeHighDate: object.allTimeHighDate,
                 lastUpdated: object.lastUpdated,
                 priceChangeIn1h: object.priceChangeIn1h,
                 priceChangeIn1y: object.priceChangeIn1y,
                 priceChangeIn24h: object.priceChangeIn24h,
                 priceChangeIn30d: object.priceChangeIn30d,
                 priceChangeIn7d: object.priceChangeIn7d)
    }
}

extension GPMarket: ManagedObjectTransformable {
    public typealias ManagedObjectType = GPManagedMarket
    
    public var managedObject: GPManagedMarket {
        return GPManagedMarket(plain: self)
    }
}

extension GPMarket: Hashable {
    public static func == (lhs: GPMarket, rhs: GPMarket) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
