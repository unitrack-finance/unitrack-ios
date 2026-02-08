//
//  DashboardView.swift
//  Unitrack
//
//  Created by Sylus Abel on 05/02/2026.
//

import SwiftUI

struct DashboardView: View {
    @State private var isSyncing = false
    @State private var selectedTimeframe = "30 Days"

    private let allocation: [AllocationItem] = [
        .init(name: "Stocks", value: 46, color: Color.blue, source: .plaid),
        .init(name: "Crypto", value: 18, color: Color.pink, source: .manual),
        .init(name: "Real Estate", value: 14, color: Color.red, source: .manual),
        .init(name: "Fixed Income", value: 12, color: Color.green, source: .plaid),
        .init(name: "Cash", value: 10, color: Color.cyan, source: .plaid)
    ]

    private let stats: [StatItem] = [
        .init(title: "Best Performer", subtitle: "AAPL", value: "+4.8%", icon: "arrow.up.right.circle.fill", isPositive: true),
        .init(title: "Worst Performer", subtitle: "ETH", value: "-2.1%", icon: "arrow.down.right.circle.fill", isPositive: false),
        .init(title: "Top Holding", subtitle: "VTI", value: "$18,420", icon: "star.circle.fill", isPositive: true),
        .init(title: "Connected Accounts", subtitle: "5 synced", value: "Verified", icon: "checkmark.seal.fill", isPositive: true)
    ]

    private let holdings: [HoldingItem] = [
        .init(name: "Vanguard Total Stock", source: "Fidelity", value: "$18,420", change: "+1.2%", isPositive: true, icon: "building.columns.fill"),
        .init(name: "Apple", source: "Robinhood", value: "$8,240", change: "+4.8%", isPositive: true, icon: "apple.logo"),
        .init(name: "Bitcoin", source: "Manual Entry", value: "$6,120", change: "-0.6%", isPositive: false, icon: "bitcoinsign.circle.fill"),
        .init(name: "Gold Bars", source: "Manual Entry", value: "$4,980", change: "+0.4%", isPositive: true, icon: "circle.grid.cross.fill"),
        .init(name: "US Treasury", source: "Schwab", value: "$3,110", change: "+0.1%", isPositive: true, icon: "chart.bar.fill")
    ]
    
    private let portfolios: [Portfolio] = [
        .init(name: "Metamask - ETH", balance: "$14,908"),
        .init(name: "Coinbase", balance: "$100,400"),
        .init(name: "Interactive Brokers", balance: "$14,500")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    DashboardHeader()
                    PortfolioOverviewCard(portfolios: portfolios, selectedTimeframe: $selectedTimeframe)
                    SyncStatusBanner(isSyncing: $isSyncing)
                    AllocationSection(allocation: allocation)
                    QuickStatsSection(stats: stats)
                    HoldingsSection(holdings: holdings)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 50)
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    DashboardView()
        .preferredColorScheme(.dark)
}
