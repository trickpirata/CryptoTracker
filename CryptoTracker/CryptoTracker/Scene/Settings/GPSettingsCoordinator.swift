//
//  GPSettingsCoordinator.swift
//  CryptoTracker
//
//  Created by Trick Gorospe on 8/30/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import Foundation
import SwiftUI
import Stinsen

class GPSettingsCoordinator: NavigationCoordinatable {
    var navigationStack: NavigationStack = NavigationStack()

    enum Route: NavigationRoute {

    }
    
    func resolveRoute(route: Route) -> Transition {
        
    }
    
    @ViewBuilder func start() -> some View {
        GPSettingsContentView()
    }
}
