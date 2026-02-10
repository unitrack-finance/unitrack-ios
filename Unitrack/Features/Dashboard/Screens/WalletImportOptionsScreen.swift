//
//  WalletImportOptionsScreen.swift
//  Unitrack
//
//  Created by Sylus Abel on 10/02/2026.
//

import SwiftUI

struct WalletImportOptionsScreen: View {
    let wallet: Connectable
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Logo
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        Image(systemName: wallet.logoUrl)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 64, height: 64)
                            .foregroundStyle(Color.orange) // Brand color placeholder
                            .padding(12)
                            .background(Color.cardBackgroundSecondary, in: Circle())
                        
                        Image(systemName: "arrow.right")
                            .foregroundStyle(Color.textSecondary)
                        
                        Text("U") // App Logo Placeholder
                            .font(.largeTitle)
                            .bold()
                            .frame(width: 64, height: 64)
                            .background(Color.cardBackgroundSecondary, in: Circle())
                    }
                    
                    Text("Import options")
                        .customFont(.title2)
                        .foregroundStyle(Color.textPrimary)
                    
                    Text("Over 500,000 users have already imported their account to Unitrack.")
                        .customFont(.body)
                        .foregroundStyle(Color.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .padding(.top, 32)
                
                // Options
                VStack(spacing: 16) {
                    NavigationLink(destination: WalletConnectionScreen(wallet: wallet, method: .publicAddress)) {
                        ImportOptionRow(title: "Public address", subtitle: "Investments (Transactions)", isPopular: true)
                    }
                    
                    NavigationLink(destination: Text("Manual Import Flow Placeholder")) {
                        ImportOptionRow(title: "Manual import", subtitle: "Investments (Transactions)", isPopular: false)
                    }
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                // Privacy Footnote
                HStack(spacing: 4) {
                    Image(systemName: "info.circle.fill")
                        .foregroundStyle(.blue)
                    Text("We take data privacy and security seriously.")
                        .foregroundStyle(Color.textSecondary)
                    Text("Learn more")
                        .foregroundStyle(.blue)
                        .bold()
                }
                .customFont(.caption)
                .padding(.bottom, 24)
            }
        }
        .background(Color.screenBackground)
        .navigationTitle(wallet.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ImportOptionRow: View {
    let title: String
    let subtitle: String
    let isPopular: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .customFont(.headline)
                        .foregroundStyle(Color.textPrimary)
                    
                    if isPopular {
                        Text("Most popular")
                            .customFont(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1), in: Capsule())
                            .foregroundStyle(.blue)
                    }
                }
                
                Text(subtitle)
                    .customFont(.caption)
                    .foregroundStyle(Color.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.textSecondary)
        }
        .padding(16)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack {
        WalletImportOptionsScreen(wallet: Supported.wallets[0])
            .preferredColorScheme(.dark)
    }
}
