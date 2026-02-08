//
//  StatCard.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import SwiftUI

struct StatCard: View {
    let item: StatItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: item.icon)
                .font(.title3)
                .foregroundStyle(item.isPositive ? .pink : .red)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .customFont(.caption)
                    .foregroundStyle(Color.textSecondary)
                Text(item.subtitle)
                    .customFont(.subheadline)
                    .foregroundStyle(Color.textPrimary)
            }
            
            Text(item.value)
                .customFont(.headline)
                .foregroundStyle(item.isPositive ? Color.accentGreen : Color.red)
        }
        .padding(16)
        .frame(width: 150, alignment: .leading)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
