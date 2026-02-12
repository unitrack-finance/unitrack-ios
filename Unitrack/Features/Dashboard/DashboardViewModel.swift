//
//  DashboardViewModel.swift
//  Unitrack
//
//  Created by Sylus Abel on 12/02/2026.
//

import SwiftUI
import Combine

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var portfolios: [Portfolio] = []
    @Published var summary: PortfolioSummary?
    @Published var holdings: [HoldingItem] = []
    @Published var allocation: [AllocationResponseItem] = []
    @Published var health: HealthResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchData() async {
        print("📊 Dashboard: Starting data fetch")
        print("📊 Token exists: \(TokenManager.shared.token != nil)")
        
        isLoading = true
        errorMessage = nil
        
        do {
            async let fetchedPortfolios = PortfolioService.shared.getPortfolios()
            async let fetchedSummary = PortfolioService.shared.getSummary()
            async let fetchedHoldings = PortfolioService.shared.getHoldings()
            async let fetchedAllocation = PortfolioService.shared.getAllocation()
            async let fetchedHealth = AnalyticsService.shared.getHealth()
            
            self.portfolios = try await fetchedPortfolios
            print("📊 Fetched \(self.portfolios.count) portfolios")
            
            self.summary = try await fetchedSummary
            print("📊 Summary total value: \(self.summary?.totalValue ?? 0)")
            
            self.holdings = try await fetchedHoldings
            print("📊 Fetched \(self.holdings.count) holdings")
            
            self.allocation = try await fetchedAllocation
            print("📊 Fetched \(self.allocation.count) allocations")
            
            self.health = try await fetchedHealth
            print("📊 Health score: \(self.health?.score ?? 0)")
            
        } catch {
            self.errorMessage = error.localizedDescription
            print("🔴 Dashboard fetch error:", error)
        }
        
        isLoading = false
        print("📊 Dashboard: Data fetch complete")
    }
}
