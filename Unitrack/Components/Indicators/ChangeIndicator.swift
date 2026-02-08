//
//  ChangeIndicator.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import SwiftUI

struct ChangeIndicator: View {
    let value: String
    let percentage: String
    let isPositive: Bool
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                .font(.caption2.weight(.bold))
            Text(value)
                .customFont(.caption)
            Text(percentage)
                .customFont(.caption)
        }
        .foregroundStyle(isPositive ? Color.accentGreen : Color.red)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(isPositive ? Color.accentGreen.opacity(0.1) : Color.red.opacity(0.15))
        )
    }
}
