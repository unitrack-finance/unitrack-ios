//
//  MiniPortfolioCard.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import SwiftUI

struct MiniPortfolioCard: View {
    let portfolio: Portfolio
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "arrow.up.right")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.black)
                    .frame(width: 24, height: 24)
                    .background(Color.white, in: Circle())
                Spacer()
            }
            
            Spacer()
            
            Text(portfolio.balance)
                .customFont(.headline)
                .foregroundStyle(Color.textPrimary)
            
            Text(portfolio.name)
                .customFont(.caption)
                .foregroundStyle(Color.textSecondary)
                .lineLimit(1)
        }
        .padding(14)
        .frame(width: 140, height: 120)
        .background(Color.cardBackgroundSecondary, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
