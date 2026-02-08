//
//  StatsGridView.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import SwiftUI

struct StatsGridView: View {
    let chartData: [PortfolioChartData]
    let formatVolume: (Double) -> String
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Statistics")
                    .customFont(.headline)
                    .foregroundStyle(Color.textPrimary)
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                StatBox(title: "Open", value: String(format: "$%.2f", chartData.first?.open ?? 0))
                StatBox(title: "High", value: String(format: "$%.2f", chartData.max(by: { $0.high < $1.high })?.high ?? 0))
                StatBox(title: "Low", value: String(format: "$%.2f", chartData.min(by: { $0.low < $1.low })?.low ?? 0))
                StatBox(title: "Volume", value: formatVolume(chartData.reduce(0) { $0 + $1.volume }))
            }
        }
        .padding(16)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
