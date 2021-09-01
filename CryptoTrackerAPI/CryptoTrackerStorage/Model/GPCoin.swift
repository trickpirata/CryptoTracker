//
//  GPCoin.swift
//  CryptoTrackerStorage
//
//  Created by Trick Gorospe on 8/30/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import Foundation

public class GPCoin: Codable {
    public let id: String
    public let symbol: String?
    public let name: String
    public var isActive: Bool = false
    
    public static var empty: GPCoin {
        return GPCoin(id: "")
    }
    private enum Keys: String, CodingKey {
        case id
        case symbol
        case name
        case isActive
    }
    
    public init(id: String, symbol: String? = "", name: String = "", isActive: Bool = false) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.isActive = isActive
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        id = try container.decode(String.self, forKey: .id)
        symbol = try container.decode(String.self, forKey: .symbol)
        name = try container.decode(String.self, forKey: .name)
        isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive) ?? false
    }
    
    public required convenience init(managed object: ManagedObjectType) {
        self.init(id: object.id,
                  symbol: object.symbol,
                  name: object.name,
                  isActive: object.isActive)
    }
}

extension GPCoin: ManagedObjectTransformable {
    public typealias ManagedObjectType = GPManagedCoin
    
    public var managedObject: GPManagedCoin {
        return GPManagedCoin(plain: self)
    }
}

extension GPCoin: Hashable, Equatable {
    public static func == (lhs: GPCoin, rhs: GPCoin) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
