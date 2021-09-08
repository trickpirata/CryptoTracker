//
//  CryptoTrackerTests.swift
//  CryptoTrackerTests
//
//  Created by Trick Gorospe on 8/30/21.
//

import XCTest
import CryptoTrackerStorage
import Combine
@testable import CryptoTracker

class GPHomeContentTests: XCTestCase {
    let viewModel = GPHomeViewModel(service: GPMockCoinService())
    var cancelBag = Set<AnyCancellable>()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetMarkets () throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let coins: [GPCoin] = viewModel.getDefaultCoins()
        
        let ids = coins
            .filter { $0.isActive }
            .map {$0.id}
            .joined(separator: ",")
         
        XCTAssert(coins.count > 0, "There should always be default coins")
        XCTAssert(ids.count > 0, "ids should be more than 0")
        
        let persistedCoinExpectation = expectation(description: "Persisted Coin Expectation")
        viewModel.getPersistedCoins().sink { coins in
            XCTAssert(coins.count > 0, "Should always have a persisted coin after calling default coin")
            persistedCoinExpectation.fulfill()
        }.store(in: &cancelBag)
        
        let coinMarketExpectation = expectation(description: "Coin Market Expectation")
        
        viewModel.getCoinMarket(forIDs: ids).sink { market in
            XCTAssert(market.count > 0, "should display markets")
            coinMarketExpectation.fulfill()
        }.store(in: &cancelBag)
        
        wait(for: [persistedCoinExpectation, coinMarketExpectation], timeout: 5.0)
    }

}
