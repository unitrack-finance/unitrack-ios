//
//  AnalyticsView.swift
//  Unitrack
//
//  Created by Sylus Abel on 05/02/2026.
//

import SwiftUI
import RevenueCat
import RevenueCatUI

struct AnalyticsView: View {
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @State private var showPaywall = false
    @State private var showAgent = false
    @State private var showExportSheet = false
    
    var body: some View {
        NavigationStack {
                ZStack(alignment: .bottomTrailing) {
                    Group {
                        if subscriptionManager.isPremium {
                            PremiumAnalyticsView()
                        } else {
                            lockedContent
                        }
                    }
                    
                    if subscriptionManager.isPremium {
                        agentFAB
                    }
                }
                .toolbar {
                    if subscriptionManager.isPremium {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                showExportSheet = true
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                    }
                }
                .sheet(isPresented: $showPaywall) {
                    PaywallView(displayCloseButton: true)
                }
                .fullScreenCover(isPresented: $showAgent) {
                    AgentChatView()
                }
                .confirmationDialog("Export Portfolio Analytics", isPresented: $showExportSheet) {
                    Button("Export to PDF") {
                         // PDF Logic placeholder
                    }
                    Button("Export to CSV") {
                        if let url = ExportService.shared.generateCSV(from: dummyPerformanceData) {
                            // In a real app, present ShareSheet
                            print("CSV Available at: \(url)")
                        }
                    }
                    Button("Cancel", role: .cancel) {}
        }
    }
}
    
    private var agentFAB: some View {
        Button {
            showAgent = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                Text("Agent")
                    .customFont(.headline)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing),
                in: Capsule()
            )
            .foregroundStyle(.white)
            .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding(20)
        .transition(.scale.combined(with: .opacity))
    }
    
    private var lockedContent: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.purple, .blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .purple.opacity(0.3), radius: 20)
            
            VStack(spacing: 12) {
                Text("Unlock Premium Insights")
                    .customFont(.title2)
                
                Text("Get detailed analysis of your portfolio risk, sector allocation, and dividend growth.")
                    .customFont(.body)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: { showPaywall = true }) {
                Text("Unlock Unitrack Pro")
                    .customFont(.headline)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(.horizontal, 32)
            
            Spacer()
            
            // Subtle "Managed by RevenueCat" or similar info
            Text("Powered by RevenueCat")
                .font(.caption2)
                .foregroundStyle(Color.textTertiary)
                .padding(.bottom, 20)
        }
    }
}

#Preview {
    AnalyticsView()
        .environmentObject(SubscriptionManager.shared)
}
