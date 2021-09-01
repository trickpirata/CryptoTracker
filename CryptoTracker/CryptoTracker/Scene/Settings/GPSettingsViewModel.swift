//
//  GPSettingsViewModel.swift
//  CryptoTracker
//
//  Created by Trick Gorospe on 8/30/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import CryptoTrackerStorage

class GPSettingsViewModel: GPObservableViewModelProtocol {
    struct Input {
        var didLoad: AnyPublisher<Void, Never>
        var didUpdateCoin: AnyPublisher<GPCoin, Never>
    }
    
    struct Output {
        
    }
    
    // MARK: - Binding
    @Published var isLoading = false
    @Published var searchText = ""
    @Published var isErrorShown = false
    @Published var errorMessage = ""
    @Published var coins:[GPCoin] = [GPCoin]()
    
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
        let marketPublisher = input.didLoad.flatMap { [weak self] _ -> AnyPublisher<[GPCoin], Never> in
            guard let self = self else {
                return Empty(completeImmediately: false).eraseToAnyPublisher()
            }
            
            return self.getCoins()
        }
        .flatMap { [weak self] _ -> AnyPublisher<[GPCoin], Never> in
            guard let self = self else {
                return Empty(completeImmediately: false).eraseToAnyPublisher()
            }
            return self.getPersistedCoins()
        }
        
        let newCoinPublisher = input.didUpdateCoin
            .receive(on: DispatchQueue.global(qos: .background))
            .flatMap { [weak self] coin -> AnyPublisher<Void, Never> in
                guard let self = self else {
                    return Empty(completeImmediately: false).eraseToAnyPublisher()
                }
                print("start: \(Thread.isMainThread)")
                let newCoin = coin
                newCoin.isActive.toggle()
                return self.persistenceService.save(object: newCoin)
            }.flatMap { [weak self] _ -> AnyPublisher<[GPCoin], Never> in
                guard let self = self else {
                    return Empty(completeImmediately: false).eraseToAnyPublisher()
                }
                print("getting: \(Thread.isMainThread)")
                return self.getPersistedCoins()
            }
        
        let marketStream = Publishers.Merge(marketPublisher, newCoinPublisher)
            .receive(on: RunLoop.main)
            .assign(to: \.coins, on: self)
        
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

    private func getPersistedCoins() -> AnyPublisher<[GPCoin], Never> {
        return persistenceService.get(at: GPCoinPersistenceRequest.allCoins)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    private func saveCoins(newObjects: [GPCoin]) -> AnyPublisher<Void, Never> {
        
        return getPersistedCoins().flatMap { [weak self] oldCoins -> AnyPublisher<Void, Never> in
            guard let self = self else {
                return Empty(completeImmediately: false).eraseToAnyPublisher()
            }
            let objects = newObjects.filter { coin in
                return !oldCoins.contains(coin)
            }
            return self.persistenceService.save(objects: objects)
        }.eraseToAnyPublisher()
    }
    
    private func getCoins() -> AnyPublisher<[GPCoin], Never> {
        return service.getCoinList()
            .catch { [weak self] error -> Empty<[GPCoin], Never> in
                self?.errorSubject.send(.parseError(error))
                self?.isLoading = false
                return .init()
            }.map({ response -> [GPCoin] in
                self.isLoading = false
                return response
            }).flatMap({ [weak self] coins -> AnyPublisher<Void, Never> in
                guard let self = self else {
                    return Empty(completeImmediately: false).eraseToAnyPublisher()
                }
                return self.saveCoins(newObjects: coins)
            }).flatMap({ [weak self] _ -> AnyPublisher<[GPCoin], Never> in
                guard let self = self else {
                    return Empty(completeImmediately: false).eraseToAnyPublisher()
                }
                return self.getPersistedCoins()
            }).eraseToAnyPublisher()
    }
}
