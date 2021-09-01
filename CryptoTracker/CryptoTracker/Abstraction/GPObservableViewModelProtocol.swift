//
//  GPObservableViewModel.swift
//  CryptoTracker
//
//  Created by Trick Gorospe on 8/30/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import Foundation

protocol GPObservableViewModelProtocol: ObservableObject {
    associatedtype Input
    associatedtype Output
    var isLoading: Bool { get set }
    func bind(_ input: Input) -> Output
//    func bind(_ input: Input)
}
