//
//  StatBox.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import SwiftUI

struct StatBox: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .customFont(.caption)
                .foregroundStyle(Color.textSecondary)
            Text(value)
                .customFont(.subheadline)
                .foregroundStyle(Color.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.cardBackgroundSecondary, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
