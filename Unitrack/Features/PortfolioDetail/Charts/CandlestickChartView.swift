//
//  CandlestickChartView.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import SwiftUI
import Charts

struct CandlestickChartView: View {
    let chartData: [PortfolioChartData]
    @Binding var selectedDate: Date?
    
    var body: some View {
        Chart(chartData) { dataPoint in
            RectangleMark(
                x: .value("Date", dataPoint.date),
                yStart: .value("Low", dataPoint.low),
                yEnd: .value("High", dataPoint.high),
                width: 2
            )
            .foregroundStyle(dataPoint.close >= dataPoint.open ? Color.accentGreen : Color.red)

            RectangleMark(
                x: .value("Date", dataPoint.date),
                yStart: .value("Open", min(dataPoint.open, dataPoint.close)),
                yEnd: .value("Close", max(dataPoint.open, dataPoint.close)),
                width: 8
            )
            .foregroundStyle(dataPoint.close >= dataPoint.open ? Color.accentGreen : Color.red)
            .opacity(0.8)
            
            if let selectedDate, selectedDate == dataPoint.date {
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
