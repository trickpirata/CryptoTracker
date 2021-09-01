//
//  GPHomeViewModel.swift
//  CryptoTracker
//
//  Created by Trick Gorospe on 8/30/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import CryptoTrackerStorage

class GPHomeViewModel: GPObservableViewModelProtocol {
    struct Input {
        var didLoad: AnyPublisher<Bool, Never>
        var didSelectCoin: AnyPublisher<String, Never>
    }

    struct Output {
        var didLoadMarket: AnyPublisher<[GPMarket], Never>
    }
    
    // MARK: - Bindings
    @Published var isLoading = false
    @Published var isErrorShown = false
    @Published var errorMessage = ""
    @Published var market:[GPMarket] = [GPMarket]()
    
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
        let didLoad = input.didLoad.share()

        let persistedCoinPublisher = didLoad.flatMap { [weak self] _ -> AnyPublisher<[GPCoin], Never> in
            guard let self = self else {
                return Empty(completeImmediately: false).eraseToAnyPublisher()
            }
            return self.getPersistedCoins()
        }
        
        let marketPublisher = Publishers.Zip(didLoad, persistedCoinPublisher)
            .flatMap { [weak self] (isFirstTime, persistedCoins) -> AnyPublisher<[GPMarket], Never> in
                guard let self = self else {
                    return Empty(completeImmediately: false).eraseToAnyPublisher()
                }
                let coins: [GPCoin] = isFirstTime ? self.getDefaultCoins() : persistedCoins
                
                let ids = coins
                    .filter { $0.isActive }
                    .map {$0.id}
                    .joined(separator: ",")


                return self.getCoinMarket(forIDs: ids)
            }
        
        let marketStream = marketPublisher
            .assign(to: \.market, on: self)
        
        
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
        let output = Output(didLoadMarket: marketPublisher.eraseToAnyPublisher())
        return output
    }
    
    private func getDefaultCoins() -> [GPCoin] {
        var coins = [GPCoin]()
        guard let path = Bundle.main.path(forResource: "CoinsDefault", ofType: "plist"),
              let data = FileManager.default.contents(atPath: path) else {
            return coins
        }
        
        do {
            let decoder = PropertyListDecoder()
            coins = try decoder.decode([GPCoin].self, from: data)
        } catch let error {
            print(error)
        }
        
        if coins.count > 0 {
            
            persistenceService.save(objects: coins).sink { _ in
                print("coins persisted")
            }.store(in: &cancelBag)
        }
        
        return coins
    }
    
    private func getPersistedCoins() -> AnyPublisher<[GPCoin], Never> {
        return persistenceService.get(at: GPCoinPersistenceRequest.allCoins)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func getCoinMarket(forIDs ids: String) -> AnyPublisher<[GPMarket], Never> {
        isLoading = true
        return service.getMarket(forCurrency: "USD", andIDs: ids, inPage: 1)
            .catch { [weak self] error -> Empty<[GPMarket], Never> in
                self?.errorSubject.send(.parseError(error))
                self?.isLoading = false
                return .init()
            }.map({ response in
                self.isLoading = false
                
                return response
            }).eraseToAnyPublisher()
    }
}
