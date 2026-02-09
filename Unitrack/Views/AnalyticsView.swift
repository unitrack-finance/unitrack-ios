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
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                if subscriptionManager.isPremium {
                    premiumContent
                } else {
                    lockedContent
                }
            }
            .navigationTitle("Analytics")
            .sheet(isPresented: $showPaywall) {
                PaywallView(displayCloseButton: true)
            }
        }
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
    
    private var premiumContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Welcome to Premium!")
                    .customFont(.headline)
                
                // Advanced charts will go here
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.cardBackground)
                    .frame(height: 200)
                    .overlay(Text("Risk Analysis Chart").foregroundStyle(Color.textSecondary))
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.cardBackground)
                    .frame(height: 200)
                    .overlay(Text("Sector Allocation").foregroundStyle(Color.textSecondary))
            }
            .padding(20)
        }
    }
}

#Preview {
    AnalyticsView()
        .environmentObject(SubscriptionManager.shared)
}
