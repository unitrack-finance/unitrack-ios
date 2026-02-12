//
//  PortfolioOverviewCard.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import SwiftUI

struct PortfolioOverviewCard: View {
    let portfolios: [Portfolio]
    let summary: PortfolioSummary?
    @Binding var selectedTimeframe: String
    var onAddPortfolio: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Total Balance")
                        .customFont(.caption)
                      
                    Text(summary?.totalValue.asCurrency ?? "$0.00")
                        .customFont(.largeTitle)
                }
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                ChangeIndicator(value: "+$1,240", percentage: "+0.97%", isPositive: true)
                Text("vs last month")
                    .customFont(.caption)
                   
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(portfolios) { portfolio in
                        NavigationLink(destination: PortfolioDetailView(portfolio: portfolio)) {
                            MiniPortfolioCard(portfolio: portfolio)
                        }
                    }
                }
            }
            
            HStack {
                Spacer()
                Button(action: onAddPortfolio) {
                    Label("Add Portfolio", systemImage: "plus.circle.fill")
                        .customFont(.body)
                }
                Spacer()
            }
            .padding(.top)
        }
        .padding(20)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}
