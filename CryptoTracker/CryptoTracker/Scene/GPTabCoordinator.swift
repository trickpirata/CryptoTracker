//
//  GPTabCoordinator.swift
//  CryptoTracker
//
//  Created by Trick Gorospe on 8/30/21.
//  Copyright © 2021 Patrick Gorospe. All rights reserved.
//

import Foundation
import SwiftUI
import Stinsen

final class GPTabCoordinator: TabCoordinatable {
    lazy var children = TabChild(self, tabRoutes: [.home, .settings])

    enum Route: TabRoute {
        case home
        case settings
    }

    func tabItem(forTab tab: Int) -> some View {
        switch tab {
        case 0:
            Group {
                if children.activeTab == 0 {
                    Image(systemName: "chart.bar.fill")
                } else {
                    Image(systemName: "chart.bar")
                }
                Text("Home")
            }
        case 1:
            Group {
                if children.activeTab == 1 {
                    Image(systemName: "gearshape.2.fill")
                } else {
                    Image(systemName: "gearshape.2")
                }
                Text("Settings")
            }
        default:
            fatalError()
        }
    }

    func resolveRoute(route: Route) -> AnyCoordinatable {
        switch route {
        case .home:
            return NavigationViewCoordinator(GPHomeCoordinator()).eraseToAnyCoordinatable()
        case .settings:
            return AnyCoordinatable(NavigationViewCoordinator(GPSettingsCoordinator()))
        }
    }
}
