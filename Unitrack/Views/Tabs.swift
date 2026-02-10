//
//  Tabs.swift
//  Unitrack
//
//  Created by Sylus Abel on 05/02/2026.
//

import SwiftUI

enum AppTabs {
    case dashboard, accounts, analytics, settings
}

struct Tabs: View {
    @State var selectedTab: AppTabs = .dashboard
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Dashboard", systemImage: "house", value: .dashboard) {
                DashboardView()
            }
            Tab("Search", systemImage: "magnifyingglass", value: .accounts) {
                AssetView()
            }
            Tab("Analytics", systemImage: "chart.pie", value: .analytics) {
                AnalyticsView()
            }
            Tab("Settings", systemImage: "gearshape", value: .settings) {
                SettingsView()
            }
        }
    }
}

#Preview {
    Tabs()
        .environmentObject(SubscriptionManager.shared)
}
