//
//  GPTestHomeViewModel.swift
//  CryptoTrackerTests
//
//  Created by Trick Gorospe on 9/8/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import Foundation
import CryptoTrackerStorage
import Combine

class GPMockCoinService: GPCoinService {
    func getCoinList() -> AnyPublisher<[GPCoin], Error> {
        let coins = [GPCoin(id: "cardano", symbol: "ADA", name: "Cardano", isActive: true),
                     GPCoin(id: "bitcoin", symbol: "BTC", name: "Bitcoin", isActive: true),
                     GPCoin(id: "ethereum", symbol: "ETH", name: "Ethereum", isActive: true)]

        return Just(coins)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getMarket(forCurrency currency: String, andIDs ids: String, inPage page: Int) -> AnyPublisher<[GPMarket], Error> {
        let markets = [GPMarket(id: "cardano"),
                       GPMarket(id: "bitcoin")]
        return Just(markets)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getMarketChart(forID id: String, usingCurrency currency: String, andDayInterval days: Int) -> AnyPublisher<GPCoinChart, Error> {
        let chart = GPCoinChart(prices: [
            [1631016005807, 3762.011754203893],
            [1631016297214, 3749.9609038180547],
            [1631016617347, 3756.4146341340042],
        ])
        return Just(chart)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
