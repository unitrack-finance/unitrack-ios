//
//  AreaChartView.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import SwiftUI
import Charts

struct AreaChartView: View {
    let chartData: [PortfolioChartData]
    @Binding var selectedDate: Date?
    
    var body: some View {
        Chart(chartData) { dataPoint in
            AreaMark(
                x: .value("Date", dataPoint.date),
                y: .value("Price", dataPoint.close)
            )
            .foregroundStyle(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.accentGreen.opacity(0.3),
                        Color.accentGreen.opacity(0.05)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            LineMark(
                x: .value("Date", dataPoint.date),
                y: .value("Price", dataPoint.close)
            )
            .foregroundStyle(Color.accentGreen)
            .lineStyle(StrokeStyle(lineWidth: 2.5))
            
            if let selectedDate, selectedDate == dataPoint.date {
                PointMark(
                    x: .value("Date", dataPoint.date),
                    y: .value("Price", dataPoint.close)
                )
                .foregroundStyle(Color.accentGreen)
                .symbolSize(80)
                
                RuleMark(x: .value("Date", dataPoint.date))
                    .foregroundStyle(Color.textTertiary.opacity(0.3))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
            }
        }
        .frame(height: 280)
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: 2)) { _ in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                    .foregroundStyle(Color.textTertiary.opacity(0.2))
                AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                    .font(.caption2)
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .chartYAxis {
            AxisMarks(position: .trailing) { value in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                    .foregroundStyle(Color.textTertiary.opacity(0.2))
                AxisValueLabel {
                    if let price = value.as(Double.self) {
                        Text("$\(Int(price))")
                            .font(.caption2)
                            .foregroundStyle(Color.textSecondary)
                    }
                }
            }
        }
        .chartYScale(domain: .automatic(includesZero: false))
        .chartXSelection(value: $selectedDate)
    }
}
