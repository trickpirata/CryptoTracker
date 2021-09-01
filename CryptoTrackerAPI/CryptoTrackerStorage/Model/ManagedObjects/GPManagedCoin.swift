//
//  GPManagedCoin.swift
//  CryptoTrackerStorage
//
//  Created by Trick Gorospe on 8/30/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import Foundation
import RealmSwift

public class GPManagedCoin: Object {
    public typealias PlainObjectType = GPCoin
    
    @Persisted var id: String = ""
    @Persisted var symbol: String = ""
    @Persisted var name: String = ""
    @Persisted var isActive: Bool = false
    
    public override static func primaryKey() -> String {
        return "id"
    }
    
    public required convenience init(plain object: PlainObjectType) {
        self.init()
        id = object.id
        symbol = object.symbol ?? ""
        name = object.name
        isActive = object.isActive
    }
}

extension GPManagedCoin: PlainObjectTransformable {
    public var plainObject: PlainObjectType {
        return GPCoin(managed: self)
    }

}
