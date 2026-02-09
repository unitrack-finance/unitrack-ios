//
//  ImportOptionsScreen.swift
//  Unitrack
//

import SwiftUI

struct ImportOptionsScreen: View {
    let institution: Institution
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 32) {
            // Visual Header
            VisualConnectionHeader(institution: institution)
            .padding(.top, 40)
            
            VStack(spacing: 12) {
                Text("Import options")
                    .customFont(.title2)
                
                Text("Over 500,000 users have already imported their account to Unitrack.")
                    .customFont(.body)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            // Options List
            VStack(spacing: 16) {
                NavigationLink(destination: AutomaticConnectionScreen(institution: institution)) {
                NavigationLink(destination: AutomaticConnectionScreen(institution: institution)) {
                    ImportOptionCard(
                        title: "Automatic connection",
                        subtitle: "Investments (Transactions)",
                        badge: "Most popular",
                        icon: "bolt.fill"
                    )
                }
                }
                
                ImportOptionCard(
                    title: "Manual import",
                    subtitle: "Investments (Transactions)",
                    icon: "square.and.pencil"
                ) {
                    // Start manual flow
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Footer
            HStack(spacing: 12) {
                Image(systemName: "info.circle.fill")
                    .foregroundStyle(.blue)
                
                Text("We take data privacy and security seriously. ")
                    .foregroundStyle(Color.textSecondary) +
                Text("Learn more")
                    .foregroundStyle(.blue)
            }
            .customFont(.caption)
            .padding(.bottom, 20)
        }
        .navigationTitle(institution.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.screenBackground)
    }
}

struct ImportOptionCard: View {
    let title: String
    let subtitle: String
    var badge: String? = nil
    let icon: String
    var action: (() -> Void)? = nil
    
    var body: some View {
        Group {
            if let action = action {
                Button(action: action) {
                    cardContent
                }
                .buttonStyle(.plain)
            } else {
                cardContent
            }
        }
    }
    
    private var cardContent: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .customFont(.headline)
                    
                    if let badge = badge {
                        Text(badge)
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.2), in: Capsule())
                            .foregroundStyle(.blue)
                    }
                }
                
                Text(subtitle)
                    .customFont(.caption)
                    .foregroundStyle(Color.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.textTertiary)
        }
        .padding(20)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    NavigationStack {
        ImportOptionsScreen(institution: Institution(name: "Trade Republic", logoName: "building.columns.fill", category: .popular))
            .preferredColorScheme(.dark)
    }
}
