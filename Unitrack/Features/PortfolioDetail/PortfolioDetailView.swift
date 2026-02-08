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

    private var sampleChartData: [PortfolioChartData] {
        let calendar = Self.calendar
        let baseData = [
            PortfolioChartData(
                value: 100.0,
                date: calendar.date(from: DateComponents(year: 2024, month: 2, day: 1))!,
                open: 95.0,
                close: 100.0,
                high: 102.0,
                low: 94.0,
                volume: 1_200_000
            ),
            PortfolioChartData(
                value: 105.0,
                date: calendar.date(from: DateComponents(year: 2024, month: 2, day: 2))!,
                open: 100.0,
                close: 105.0,
                high: 108.0,
                low: 99.0,
                volume: 1_450_000
            ),
            PortfolioChartData(
                value: 102.0,
                date: calendar.date(from: DateComponents(year: 2024, month: 2, day: 5))!,
                open: 105.0,
                close: 102.0,
                high: 106.0,
                low: 101.0,
                volume: 1_100_000
            ),
            PortfolioChartData(
                value: 110.0,
                date: calendar.date(from: DateComponents(year: 2024, month: 2, day: 6))!,
                open: 102.0,
                close: 110.0,
                high: 112.0,
                low: 101.0,
                volume: 1_800_000
            ),
            PortfolioChartData(
                value: 108.0,
                date: calendar.date(from: DateComponents(year: 2024, month: 2, day: 7))!,
                open: 110.0,
                close: 108.0,
                high: 111.0,
                low: 107.0,
                volume: 1_300_000
            ),
            PortfolioChartData(
                value: 115.0,
                date: calendar.date(from: DateComponents(year: 2024, month: 2, day: 8))!,
                open: 108.0,
                close: 115.0,
                high: 116.0,
                low: 107.5,
                volume: 1_650_000
            ),
            PortfolioChartData(
                value: 112.0,
                date: calendar.date(from: DateComponents(year: 2024, month: 2, day: 9))!,
                open: 115.0,
                close: 112.0,
                high: 117.0,
                low: 111.0,
                volume: 1_400_000
            ),
            PortfolioChartData(
                value: 118.0,
                date: calendar.date(from: DateComponents(year: 2024, month: 2, day: 12))!,
                open: 112.0,
                close: 118.0,
                high: 119.0,
                low: 111.5,
                volume: 1_900_000
            )
        ]
        return baseData
    }
    
    private let assets: [Asset] = [
        .init(ticker: "MSFT", name: "Microsoft", price: "$292.66", imageUrl: "https://companieslogo.com/img/orig/MSFT-a203b22d.png?t=1722952497"),
        .init(ticker: "ETH", name: "Ethereum", price: "$2077.25", imageUrl: "https://cdn.pixabay.com/photo/2021/05/24/09/15/ethereum-logo-6278329_1280.png"),
        .init(ticker: "AAPL", name: "Apple", price: "$456.87", imageUrl: "https://g.foolcdn.com/art/companylogos/square/aapl.png"),
        .init(ticker: "DOW", name: "Dow Jones", price: "$26,598.12", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMU2Zf9sCjK9NFBEIy3OAiD7AqEy1_vXv4pg&s")
    ]
    
    private var displayedValue: String {
        if let selectedDate, let selected = sampleChartData.first(where: { $0.date == selectedDate }) {
            return String(format: "$%.2f", selected.close)
        }
        return portfolio.balance
    }
    
    private var displayedChange: (value: String, percentage: String, isPositive: Bool) {
        guard let selectedDate, let selected = sampleChartData.first(where: { $0.date == selectedDate }) else {
            return ("+$1,980", "+0.92%", true)
        }
        let change = selected.close - selected.open
        let percentChange = (change / selected.open) * 100
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
                    if chartType == .area {
                        AreaChartView(chartData: sampleChartData, selectedDate: $selectedDate)
                    } else {
                        CandlestickChartView(chartData: sampleChartData, selectedDate: $selectedDate)
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
                
                StatsGridView(chartData: sampleChartData, formatVolume: formatVolume)
                
                PositionView(assets: assets)
                
                Spacer()
            }
            .padding(20)
        }
        .background(Color.screenBackground)
        .navigationTitle(portfolio.name)
        .navigationBarTitleDisplayMode(.inline)
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
