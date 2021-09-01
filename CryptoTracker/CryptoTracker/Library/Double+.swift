//
//  Double+.swift
//  CryptoTracker
//
//  Created by Trick Gorospe on 9/1/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import Foundation

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
