//
//  GPHomeDetailViewModel.swift
//  CryptoTracker
//
//  Created by Trick Gorospe on 8/31/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import CryptoTrackerStorage

enum GPHomeDetailDayInterval: Int, Equatable, CaseIterable {
    case oneDay = 1
    case sevenDays = 7
    case fourteenDays = 14
    case thirtyDays = 30
    case oneYear = 365
    
    var title: String {
        switch self {
        case .oneDay: return "1D"
        case .sevenDays: return "7D"
        case .fourteenDays: return "14D"
        case .thirtyDays: return "30D"
        case .oneYear: return "1Y"
        }
    }
}

class GPHomeDetailViewModel: GPObservableViewModelProtocol {
    struct Input {
        var didLoad: AnyPublisher<String, Never>
    }

    struct Output {
    
    }
    
    // MARK: - Bindings
    @Published var selectedDayIndex: GPHomeDetailDayInterval = .oneDay
    @Published var isLoading = false
    @Published var isErrorShown = false
    @Published var errorMessage = ""
    @Published var marketChartValues: [Double] = [Double]()
    
    // MARK: - Services
    private let service: GPCoinService
    private let persistenceService: GPPersistenceService
    
    private let errorSubject = PassthroughSubject<GPAPIServiceError, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    init(service: GPCoinService = GPCoinServiceImp()) {
        self.service = service
        self.persistenceService = GPPersistenceService(configuration: .defaultConfiguration)
    }
    
    func bind(_ input: Input) -> Output {
        let marketPublisher = Publishers.CombineLatest(input.didLoad, $selectedDayIndex).flatMap { [weak self](marketID, day) -> AnyPublisher<[Double], Never> in
            guard let self = self else {
                return Empty(completeImmediately: false).eraseToAnyPublisher()
            }
            
            return self.getCoinMarketChart(forID: marketID, dayInterval: day.rawValue)
                .map { $0.prices }
                .map { self.getPrices($0) }
                .eraseToAnyPublisher()
        }

        let marketStream = marketPublisher
            .assign(to: \.marketChartValues, on: self)
        
        
        let errorMessageStream = errorSubject
            .map { error -> String in
                switch error {
                case .responseError(let message): return message
                case .parseError(let error): return error.localizedDescription
                }
            }
            .assign(to: \.errorMessage, on: self)
        
        let errorStream = errorSubject
            .map { _ in true }
            .assign(to: \.isErrorShown, on: self)
    
        //Cancellables
        [errorStream,
        errorMessageStream,
        marketStream].store(in: &cancelBag)

        return Output()
    }
    
    private func getCoinMarketChart(forID id: String,dayInterval day: Int) -> AnyPublisher<GPCoinChart, Never> {
        isLoading = true
        return service.getMarketChart(forID: id, usingCurrency: "USD", andDayInterval: day)
            .catch { [weak self] error -> Empty<GPCoinChart, Never> in
                self?.errorSubject.send(.parseError(error))
                self?.isLoading = false
                return .init()
            }.map({ response in
                self.isLoading = false
                return response
            }).eraseToAnyPublisher()
    }
    
    private func getPrices(_ prices: [[Double]]) -> [Double] {
        return prices.compactMap { data in
            return data[1] //we get only the price
        }
    }
}
