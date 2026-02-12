//
//  AllocationSection.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import SwiftUI

struct AllocationSection: View {
    let allocationItems: [AllocationResponseItem]
    
    private var uiItems: [AllocationItem] {
        allocationItems.map { item in
            AllocationItem(
                name: item.category,
                value: Int(item.value),
                color: color(for: item.category),
                source: .manual // Placeholder as response doesn't provide source
            )
        }
    }
    
    private func color(for category: String) -> Color {
        switch category.lowercased() {
        case "stocks": return .blue
        case "crypto": return .orange
        case "real estate": return .green
        case "cash": return .teal
        default: return .purple
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Portfolio Allocation")
                    .customFont(.headline)
                   
                Spacer()
                NavigationArrowButton(action: {})
            }

            HStack(spacing: 20) {
                AllocationRingView(items: uiItems)
                    .frame(height: 300)
            }
        }
        .padding(20)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}
