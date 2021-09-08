//
//  GPCoinChart.swift
//  CryptoTrackerStorage
//
//  Created by Trick Gorospe on 9/1/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import Foundation

public struct GPCoinChart: Codable {
    public let prices: [[Double]]
    
    public init(prices: [[Double]]) {
        self.prices = prices
    }
}
