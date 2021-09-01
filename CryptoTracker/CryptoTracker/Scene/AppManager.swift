//
//  AppManager.swift
//  CryptoTracker
//
//  Created by Trick Gorospe on 9/1/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import Foundation
import SwiftUI
import CryptoTrackerStorage

class GPAppManager {
    static let defaultManager: GPAppManager = GPAppManager()

    var isFirstTime: Bool = true {
        didSet {
            userDefaults.set(isFirstTime, forKey: Keys.isFirstTime.rawValue)
        }
    }
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        if let _ = userDefaults.object(forKey: Keys.isFirstTime.rawValue) {
            isFirstTime = userDefaults.bool(forKey: Keys.isFirstTime.rawValue)
        } else {
            isFirstTime = true
        }
    }
}

private extension GPAppManager {
    enum Keys: String {
        case isFirstTime
    }
}
