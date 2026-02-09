//
//  PortfolioTypeCard.swift
//  Unitrack
//
//  Created by Sylus Abel on 09/02/2026.
//

import SwiftUI

struct PortfolioTypeCard: View {
    let portfolioType: PortfolioType
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
        VStack(alignment: .leading, spacing: 12) {
           
            
            HStack(spacing: 16) {
                Image(systemName: portfolioType.icon)
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(portfolioType.accentColor, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(portfolioType.title)
                        .customFont(.headline)
                        .foregroundStyle(Color.textPrimary)
                    
                    Text(portfolioType.description)
                        .customFont(.caption)
                        .foregroundStyle(Color.textSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.textTertiary)
            }
            .padding(16)
            .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
    }
}
