//
//  DashboardView.swift
//  Unitrack
//
//  Created by Sylus Abel on 05/02/2026.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @State private var isSyncing = false
    @State private var selectedTimeframe = "30 Days"
    @State private var showAddPortfolio = false
    @State private var selectedPortfolioType: PortfolioType?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    DashboardHeader()
                    
                    PortfolioOverviewCard(
                        portfolios: viewModel.portfolios,
                        summary: viewModel.summary,
                        selectedTimeframe: $selectedTimeframe,
                        onAddPortfolio: { showAddPortfolio = true }
                    )
                    
                    if let health = viewModel.health {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Portfolio Health")
                                    .customFont(.headline)
                                    .foregroundStyle(Color.textPrimary)
                                Spacer()
                                Text("\(health.score)/100")
                                    .customFont(.title2)
                                    .bold()
                                    .foregroundStyle(health.score >= 70 ? .green : (health.score >= 40 ? .yellow : .red))
                            }
                            
                            Text(health.summary)
                                .customFont(.subheadline)
                                .foregroundStyle(Color.textSecondary)
                                .lineLimit(2)
                        }
                        .padding()
                        .background(Color.cardBackground)
                        .cornerRadius(16)
                    }
                    
                    SyncStatusBanner(isSyncing: $isSyncing)
                    
                    if !viewModel.allocation.isEmpty {
                        AllocationSection(allocationItems: viewModel.allocation)
                    }
                    
                    // Quick Stats could be fetched or derived, keeping for now
                    QuickStatsSection(stats: []) 
                    
                    HoldingsSection(holdings: viewModel.holdings)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 50)
            }
            .scrollIndicators(.hidden)
            .refreshable {
                await viewModel.fetchData()
            }
            .task {
                await viewModel.fetchData()
            }
            .navigationDestination(item: $selectedPortfolioType) { type in
                switch type {
                case .investments:
                    InvestmentsScreen()
                case .cash:
                    CashScreen()
                case .liabilities:
                    LiabilitiesScreen()
                }
            }
            .sheet(isPresented: $showAddPortfolio) {
                AddPortfolioSheet(onSelect: { type in
                    showAddPortfolio = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        selectedPortfolioType = type
                    }
                })
            }
        }
    }
}

#Preview {
    DashboardView()
        .preferredColorScheme(.dark)
}
