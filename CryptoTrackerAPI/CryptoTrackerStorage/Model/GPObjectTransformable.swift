//
//  GPObjectTransformable.swift
//  CryptoTrackerStorage
//
//  Created by Trick Gorospe on 8/30/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import Foundation
import RealmSwift

public protocol ManagedObjectTransformable {
    associatedtype ManagedObjectType: Object, PlainObjectTransformable where ManagedObjectType.PlainObjectType == Self

    var managedObject: ManagedObjectType { get }

    init(managed object: ManagedObjectType)
}

public protocol PlainObjectTransformable {
    associatedtype PlainObjectType: ManagedObjectTransformable where PlainObjectType.ManagedObjectType == Self

    var plainObject: PlainObjectType { get }

    init(plain object: PlainObjectType)
}
