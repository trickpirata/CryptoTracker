//
//  GPMainCoordinator.swift
//  CryptoTracker
//
//  Created by Trick Gorospe on 8/30/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import SwiftUI
import Stinsen

class MainCoordinator: ViewCoordinatable {
    var children = ViewChild()
    
    enum Route: ViewRoute {
        case home
    }

    func resolveRoute(route: Route) -> AnyCoordinatable {
        return AnyCoordinatable (
            GPTabCoordinator()
        )
    }
    
    @ViewBuilder func start() -> some View {
        GPSplashContentView()
    }
}
