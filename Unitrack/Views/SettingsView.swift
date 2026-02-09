//
//  SettingsView.swift
//  Unitrack
//
//  Created by Sylus Abel on 05/02/2026.
//

import SwiftUI
import RevenueCatUI

struct SettingsView: View {
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @State private var showCustomerCenter = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Subscription") {
                    HStack {
                        Image(systemName: "star.circle.fill")
                            .foregroundStyle(.orange)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(subscriptionManager.isPremium ? "Unitrack Pro" : "Unitrack Free")
                                .customFont(.headline)
                            Text(subscriptionManager.isPremium ? "Premium features unlocked" : "Upgrade to unlock advanced insights")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Button("Manage Subscription") {
                        showCustomerCenter = true
                    }
                }

                Section("Account Connections") {
                    HStack {
                        Image(systemName: "link.circle.fill")
                            .foregroundStyle(.blue)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Connected Institutions")
                            Text("No accounts connected")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Button("Manage Connections") {}
                }

                Section("Sync Preferences") {
                    Toggle("Auto-sync", isOn: .constant(true))
                    NavigationLink("Sync Frequency") {}
                    Toggle("Wi-Fi only", isOn: .constant(false))
                }

                Section("Privacy & Security") {
                    Label("How We Use Plaid", systemImage: "lock.shield")
                    Label("Data Encryption", systemImage: "checkmark.seal.fill")
                    Link("Plaid Privacy Policy", destination: URL(string: "https://plaid.com/legal/")!)
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showCustomerCenter) {
                CustomerCenterView()
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SubscriptionManager.shared)
}
