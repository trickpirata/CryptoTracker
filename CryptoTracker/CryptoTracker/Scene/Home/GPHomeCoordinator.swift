//
//  GPHomeCoordinator.swift
//  CryptoTracker
//
//  Created by Trick Gorospe on 8/30/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import Foundation
import SwiftUI
import Stinsen

class GPHomeCoordinator: NavigationCoordinatable {
    var navigationStack: NavigationStack = NavigationStack()

    enum Route: NavigationRoute {
        case detail(marketID: String, title: String,subtitle: String)
    }

    func resolveRoute(route: Route) -> Transition {
        switch route {
        case .detail(marketID: let marketID, title: let title, subtitle: let subtitle) :
            return .push(AnyView(GPHomeDetailContentView(withMarketID: marketID, withTitle: title, andSubTitle: subtitle)))
        }
    }

    @ViewBuilder func start() -> some View {
        GPHomeContentView()
    }
}
