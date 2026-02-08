//
//  VolumeChartView.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import SwiftUI
import Charts

struct VolumeChartView: View {
    let chartData: [PortfolioChartData]
    let formatVolume: (Double) -> String
    
    var body: some View {
        Chart(chartData) { dataPoint in
            BarMark(
                x: .value("Date", dataPoint.date),
                y: .value("Volume", dataPoint.volume)
            )
            .foregroundStyle(
                dataPoint.close >= dataPoint.open 
                    ? Color.accentGreen.opacity(0.3) 
                    : Color.red.opacity(0.3)
            )
            .cornerRadius(2)
        }
        .frame(height: 60)
        .chartXAxis(.hidden)
        .chartYAxis {
            AxisMarks(position: .trailing) { value in
                AxisValueLabel {
                    if let volume = value.as(Double.self) {
                        Text("\(formatVolume(volume))")
                            .font(.caption2)
                            .foregroundStyle(Color.textTertiary)
                    }
                }
            }
        }
    }
}
