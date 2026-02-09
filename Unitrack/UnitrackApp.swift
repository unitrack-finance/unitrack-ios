 //
//  UnitrackApp.swift
//  Unitrack
//
//  Created by Sylus Abel on 28/01/2026.
//

import SwiftUI
import SwiftData
import RevenueCat

@main
struct UnitrackApp: App {
    @StateObject private var subscriptionManager = SubscriptionManager.shared

    init() {
        // Configure RevenueCat
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "test_MUdrghvVuaLcXFUPvAeuFidPhFh")
    }

    var body: some Scene {
        WindowGroup {
            OnboardingView()
                .environmentObject(subscriptionManager)
        }
    }
}
