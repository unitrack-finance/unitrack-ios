//
//  PortfolioOverviewCard.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import SwiftUI

struct PortfolioOverviewCard: View {
    let portfolios: [Portfolio]
    @Binding var selectedTimeframe: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Total Balance")
                        .customFont(.caption)
                      
                    Text("$128,540")
                        .customFont(.prominentTitle)
                        
                }
                
                Spacer()
                
                Menu {
                    Button("7 Days") { selectedTimeframe = "7 Days" }
                    Button("30 Days") { selectedTimeframe = "30 Days" }
                    Button("90 Days") { selectedTimeframe = "90 Days" }
                    Button("1 Year") { selectedTimeframe = "1 Year" }
                } label: {
                    HStack(spacing: 4) {
                        Text(selectedTimeframe)
                            .customFont(.caption)
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                    }
                  
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.textTertiary, lineWidth: 1)
                    )
                }
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
                Button(action: {
                    print("Add Portfolio button tapped")
                }) {
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
