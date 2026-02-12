//
//  PositionsView.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import SwiftUI

struct PositionView: View {
    let holdings: [HoldingItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Positions")
                .customFont(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(holdings) { item in
                    AssetCard(item: item)
                }
            }
        }
    }
}

private struct AssetCard: View {
    let item: HoldingItem
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                if let icon = item.icon, let url = URL(string: icon) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        placeholderIcon
                    }
                } else {
                    placeholderIcon
                }
            }
            .frame(width: 48, height: 48)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.ticker ?? item.name)
                    .customFont(.subheadline)
                    .foregroundStyle(Color.textPrimary)
                
                Text(item.name)
                    .customFont(.caption)
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(item.valueString)
                    .customFont(.body)
                    .foregroundStyle(Color.textPrimary)
                
                if let price = item.price {
                    Text(String(format: "$%.2f", price))
                        .customFont(.caption2)
                        .foregroundStyle(Color.textSecondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private var placeholderIcon: some View {
        Circle()
            .fill(Color.cardBackgroundSecondary)
            .overlay(
                Image(systemName: "briefcase.fill")
                    .foregroundStyle(Color.textSecondary)
                    .font(.system(size: 20))
            )
    }
}
