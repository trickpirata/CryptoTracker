//
//  GPAPIServiceError.swift
//  CryptoTrackerStorage
//
//  Created by Trick Gorospe on 8/30/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import Foundation

public enum GPAPIServiceError: Error {
    case responseError(String)
    case parseError(Error)
}
