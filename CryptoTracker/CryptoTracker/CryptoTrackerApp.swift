//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Trick Gorospe on 8/30/21.
//

import SwiftUI
import Stinsen
import AlamofireNetworkActivityLogger

@main
struct CryptoTrackerApp: App {
    @UIApplicationDelegateAdaptor(CryptoTrackerAppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView(
                MainCoordinator()
            )
        }
    }
}

class CryptoTrackerAppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        #if DEBUG
        NetworkActivityLogger.shared.level = .debug
        #else
        NetworkActivityLogger.shared.level = .error
        #endif
        
        NetworkActivityLogger.shared.startLogging()
        return true
    }
}
