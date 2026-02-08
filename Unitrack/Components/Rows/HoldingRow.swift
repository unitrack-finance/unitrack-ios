//
//  HoldingRow.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import SwiftUI

struct HoldingRow: View {
    let item: HoldingItem

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: item.icon)
                .font(.body)
                .foregroundStyle(Color.textPrimary)
                .frame(width: 40, height: 40)
                .background(Color.cardBackgroundSecondary, in: RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 3) {
                Text(item.name)
                    .customFont(.subheadline)
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(1)
                Text(item.source)
                    .customFont(.caption)
                    .foregroundStyle(Color.textTertiary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 3) {
                Text(item.value)
                    .customFont(.subheadline)
                    .foregroundStyle(Color.textPrimary)
                Text(item.change)
                    .customFont(.caption)
                    .foregroundStyle(item.isPositive ? Color.accentGreen : Color.red)
            }
        }
        .padding(14)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
