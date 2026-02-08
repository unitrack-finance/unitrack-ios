//
//  SyncStatusBanner.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import SwiftUI

struct SyncStatusBanner: View {
    @Binding var isSyncing: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isSyncing ? "arrow.triangle.2.circlepath.circle.fill" : "checkmark.seal.fill")
                .font(.title3)
                .foregroundStyle(isSyncing ? .orange : .accentGreen)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(isSyncing ? "Syncing with Fidelity…" : "All accounts up to date")
                    .customFont(.subheadline)
                    
                Text(isSyncing ? "Updating holdings" : "Last sync 2 hours ago")
                    .customFont(.caption)
                   
            }
            
            Spacer()
            
            if isSyncing {
                ProgressView()
                    .tint(.textSecondary)
            } else {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) { isSyncing.toggle() }
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.subheadline)
                        
                }
            }
        }
        .padding(16)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
