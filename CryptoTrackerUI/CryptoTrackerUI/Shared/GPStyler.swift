//
//  GPStyler.swift
//  CryptoTrackerUI
//
//  Created by Trick Gorospe on 8/30/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import Foundation
import SwiftUI

/// Defines styling constants.
public protocol GPStyler {
    var color: GPColorStyler { get }
    var dimension: GPDimensionStyler { get }
    var appearance: GPAppearanceStyler { get }
}

/// Defines default values for style constants.
public extension GPStyler {
    var color: GPColorStyler { GPColorStyle() }
    var dimension: GPDimensionStyler { GPDimensionStyle() }
    var appearance: GPAppearanceStyler { GPAppearanceStyle() }
}

// Concrete object that contains style constants.
public struct GPStyle: GPStyler {
    public init() {}
}

private struct StyleEnvironmentKey: EnvironmentKey {
    static var defaultValue: GPStyler = GPStyle()
}

public extension EnvironmentValues {

    /// Style constants that can be used by a view.
    var defaultStyle: GPStyler {
        get { self[StyleEnvironmentKey.self] }
        set { self[StyleEnvironmentKey.self] = newValue }
    }
}

public extension View {

    /// Provide style constants that can be used by a view.
    /// - Parameter style: Style constants that can be used by a view.
    func defaultStyle(_ style: GPStyler) -> some View {
        return self.environment(\.defaultStyle, style)
    }
}

