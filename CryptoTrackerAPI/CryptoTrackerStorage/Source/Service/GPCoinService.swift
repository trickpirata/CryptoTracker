//
//  GPCoinService.swift
//  CryptoTrackerStorage
//
//  Created by Trick Gorospe on 8/30/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import Foundation
import Combine

public protocol GPCoinService {
    func getCoinList() -> AnyPublisher<[GPCoin], Error>
    func getMarket(forCurrency currency: String,andIDs ids: String,inPage page: Int) -> AnyPublisher<[GPMarket], Error>
    func getMarketChart(forID id: String,usingCurrency currency: String,andDayInterval days: Int) -> AnyPublisher<GPCoinChart, Error>
}

public final class GPCoinServiceImp: GPAPIService, GPCoinService {
    
    public override init() {
        super.init()
    }
    
    public func getCoinList() -> AnyPublisher<[GPCoin], Error> {
        return request(resource: GPAPIResource.coinList)
    }
    
    public func getMarket(forCurrency currency: String,andIDs ids: String,inPage page: Int) -> AnyPublisher<[GPMarket], Error> {
        return request(resource: GPAPIResource.markets(currency: currency, cryptoIDs: ids, page: page))
    }
    
    public func getMarketChart(forID id: String,usingCurrency currency: String,andDayInterval days: Int) -> AnyPublisher<GPCoinChart, Error> {
        return request(resource: GPAPIResource.marketChart(currency: currency, id: id, days: days))
    }
}
