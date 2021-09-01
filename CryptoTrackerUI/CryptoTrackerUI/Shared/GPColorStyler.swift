//
//  GPColorStyler.swift
//  CryptoTrackerUI
//
//  Created by Trick Gorospe on 8/30/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import UIKit

/// Defines color constants.
public protocol GPColorStyler {

    #if os(iOS)

    var label: UIColor { get }
    var secondaryLabel: UIColor { get }
    var tertiaryLabel: UIColor { get }

    var separator: UIColor { get }

    var customFill: UIColor { get }
    var secondaryCustomFill: UIColor { get }
    var tertiaryCustomFill: UIColor { get }
    var quaternaryCustomFill: UIColor { get }

    var customBlue: UIColor { get }

    var customGray: UIColor { get }
    var customGray2: UIColor { get }
    var customGray3: UIColor { get }
    var customGray4: UIColor { get }
    var customGray5: UIColor { get }

    #endif

    var white: UIColor { get }
    var black: UIColor { get }
    var clear: UIColor { get }

    var customBackground: UIColor { get }
    var primaryCustomBackground: UIColor { get }
    var secondaryCustomBackground: UIColor { get }
    
    var borderColor: UIColor { get }
    
    var buttonColor1: UIColor { get }
    var buttonColor2: UIColor { get }

    var customGroupedBackground: UIColor { get }
    var secondaryCustomGroupedBackground: UIColor { get }
    var tertiaryCustomGroupedBackground: UIColor { get }
    
}

/// Defines default values for color constants.
public extension GPColorStyler {

    var label: UIColor { .label }
    var secondaryLabel: UIColor { .secondaryLabel }
    var tertiaryLabel: UIColor { .tertiaryLabel }

    var separator: UIColor { .separator }

    var customBackground: UIColor { .systemBackground }
    var primaryCustomBackground: UIColor { UIColor(red: 245.0/255, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1) }
    var secondaryCustomBackground: UIColor { UIColor(red: 0, green: 0, blue: 0, alpha: 0.04) }

    var borderColor: UIColor { .black.withAlphaComponent(0.1) }
    
    var buttonColor1: UIColor { UIColor(red: 46.0/255.0, green: 123.0/255.0, blue: 232.0/255.0, alpha: 1.0) }
    var buttonColor2: UIColor { .white }
    var buttonColor3: UIColor { UIColor(red: 64.0/255.0, green: 94.0/255.0, blue: 255.0/255.0, alpha: 1.0)}

    var customGroupedBackground: UIColor { .systemGroupedBackground }
    var secondaryCustomGroupedBackground: UIColor { .secondarySystemGroupedBackground }
    var tertiaryCustomGroupedBackground: UIColor { .tertiarySystemGroupedBackground }

    var customFill: UIColor { .tertiarySystemFill }
    var secondaryCustomFill: UIColor { .secondarySystemFill }
    var tertiaryCustomFill: UIColor { .tertiarySystemFill }
    var quaternaryCustomFill: UIColor { .quaternarySystemFill }

    var customBlue: UIColor { .systemBlue }

    var customGray: UIColor { .systemGray }
    var customGray2: UIColor { .systemGray2 }
    var customGray3: UIColor { .systemGray3 }
    var customGray4: UIColor { .systemGray4 }
    var customGray5: UIColor { .systemGray5 }
    var customGray6: UIColor { UIColor(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.00) }
    var customVerticalCard: UIColor { UIColor(red: 0.249, green: 0.368, blue: 1.000, alpha: 1.00) }

    var white: UIColor { .white }
    var black: UIColor { .black }
    var clear: UIColor { .clear }
}

/// Concrete object for color constants.
public struct GPColorStyle: GPColorStyler {
    public init() {}
}
