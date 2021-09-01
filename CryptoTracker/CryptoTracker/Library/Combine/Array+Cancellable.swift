//
//  Array+Cancellable.swift
//
//  Created by Trick Gorospe on 8/20/21.
//

import Foundation
import Combine

extension Array where Element == AnyCancellable {
    public func store(in set: inout Set<AnyCancellable>) {
        forEach { $0.store(in: &set) }
    }
}
