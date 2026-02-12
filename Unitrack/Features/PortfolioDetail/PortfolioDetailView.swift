//
//  PortfolioDetailView.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import SwiftUI

struct PortfolioDetailView: View {
    let portfolio: Portfolio
    private static let calendar = Calendar.current
    
    @State private var fullPortfolio: Portfolio?
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    @State private var selectedTimePeriod: TimePeriod = .oneMonth
    @State private var selectedDate: Date?
    @State private var chartType: ChartType = .area
    
    enum TimePeriod: String, CaseIterable {
        case oneDay = "1D"
        case oneWeek = "1W"
        case oneMonth = "1M"
        case threeMonths = "3M"
        case oneYear = "1Y"
        case all = "ALL"
    }
    
    enum ChartType: String, CaseIterable {
        case area = "Area"
        case candlestick = "Candle"
    }

    private var chartData: [PortfolioChartData] {
        guard let snapshots = fullPortfolio?.snapshots else { return [] }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var results: [PortfolioChartData] = []
        var previousValue: Double?
        
        for snapshot in snapshots {
            if let date = formatter.date(from: snapshot.date) {
                let currentVal = snapshot.value
                let openVal = previousValue ?? currentVal
                
                results.append(PortfolioChartData(
                    value: currentVal,
                    date: date,
                    open: openVal,
                    close: currentVal,
                    high: max(openVal, currentVal),
                    low: min(openVal, currentVal),
                    volume: 0
                ))
                previousValue = currentVal
            }
        }
        return results.sorted { $0.date < $1.date }
    }
    
    
    private var displayedValue: String {
        if let selectedDate, let selected = chartData.first(where: { $0.date == selectedDate }) {
            return String(format: "$%.2f", selected.close)
        }
        return fullPortfolio?.balanceFormatted ?? portfolio.balanceFormatted
    }
    
    private var displayedChange: (value: String, percentage: String, isPositive: Bool) {
        guard let selectedDate, let selected = chartData.first(where: { $0.date == selectedDate }) else {
            // Default to overall portfolio change if available, otherwise just mock or 0
            return ("+$0.00", "0.00%", true)
        }
        let change = selected.close - selected.open
        let percentChange = selected.open != 0 ? (change / selected.open) * 100 : 0
        let isPositive = change >= 0
        return (
            String(format: "%@$%.2f", isPositive ? "+" : "", abs(change)),
            String(format: "%@%.2f%%", isPositive ? "+" : "", percentChange),
            isPositive
        )
    }
    
    private var displayedDate: String {
        if let selectedDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: selectedDate)
        }
        return Date().formatted(.dateTime.day().month(.wide).year())
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(displayedValue)
                        .customFont(.largeTitle)
                        .foregroundStyle(Color.textPrimary)
                    
                    HStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: displayedChange.isPositive ? "arrow.up.right" : "arrow.down.right")
                                .font(.caption2.weight(.bold))
                            Text(displayedChange.value)
                                .customFont(.subheadline)
                            Text(displayedChange.percentage)
                                .customFont(.subheadline)
                        }
                        .foregroundStyle(displayedChange.isPositive ? Color.accentGreen : Color.red)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(displayedChange.isPositive ? Color.accentGreen.opacity(0.1) : Color.red.opacity(0.15))
                        )
                        
                        Text(displayedDate)
                            .customFont(.caption)
                            .foregroundStyle(Color.textSecondary)
                    }
                }
                
                HStack(spacing: 8) {
                    ForEach(ChartType.allCases, id: \.self) { type in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                chartType = type
                            }
                        }) {
                            Text(type.rawValue)
                                .customFont(.caption)
                                .foregroundStyle(chartType == type ? Color.textPrimary : Color.textSecondary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(chartType == type ? Color.cardBackgroundSecondary : Color.clear)
                                )
                        }
                    }
                    
                    Spacer()
                }
                
                VStack(spacing: 12) {
                    if isLoading {
                        ProgressView()
                            .frame(height: 200)
                    } else if chartData.isEmpty {
                        ContentUnavailableView("No Chart Data", systemImage: "chart.line.uptrend.xyaxis", description: Text("Historical data is not yet available for this portfolio."))
                            .frame(height: 200)
                    } else {
                        if chartType == .area {
                            AreaChartView(chartData: chartData, selectedDate: $selectedDate)
                        } else {
                            CandlestickChartView(chartData: chartData, selectedDate: $selectedDate)
                        }
                    }
                }
                
                HStack(spacing: 0) {
                    ForEach(TimePeriod.allCases, id: \.self) { period in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedTimePeriod = period
                                selectedDate = nil
                            }
                        }) {
                            Text(period.rawValue)
                                .customFont(.caption)
                                .foregroundStyle(selectedTimePeriod == period ? Color.textPrimary : Color.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(selectedTimePeriod == period ? Color.cardBackgroundSecondary : Color.clear)
                                )
                        }
                    }
                }
                .padding(4)
                .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                
                StatsGridView(chartData: chartData, formatVolume: formatVolume)
                
                if let holdings = fullPortfolio?.holdings {
                    PositionView(holdings: holdings)
                }
                
                Spacer()
            }
            .padding(20)
        }
        .background(Color.screenBackground)
        .navigationTitle(portfolio.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchData()
        }
    }
    
    private func fetchData() {
        isLoading = true
        Task {
            do {
                let detail = try await PortfolioService.shared.getPortfolioDetail(id: portfolio.id)
                await MainActor.run {
                    self.fullPortfolio = detail
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.userFriendlyMessage
                    self.isLoading = false
                }
            }
        }
    }

    private func formatVolume(_ volume: Double) -> String {
        if volume >= 1_000_000 {
            return String(format: "%.1fM", volume / 1_000_000)
        } else if volume >= 1_000 {
            return String(format: "%.1fK", volume / 1_000)
        }
        return String(format: "%.0f", volume)
    }
}
