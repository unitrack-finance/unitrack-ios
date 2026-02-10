//
//  AssetDetailsView.swift
//  Unitrack
//
//  Created by Sylus Abel on 10/02/2026.
//

import SwiftUI
import Charts

struct AssetDetailsView: View {
    let asset: AssetSearchResult
    @State private var selectedTimeRange = "1M"
    
    // Mock Data based on user provided JSON
    let appleDetails = AssetDetails(
        ticker: "AAPL",
        name: "Apple Inc.",
        description: "Apple designs a wide variety of consumer electronic devices, including smartphones (iPhone), tablets (iPad), PCs (Mac), smartwatches (Apple Watch), AirPods, and TV boxes (Apple TV).",
        marketCap: 2771126040150,
        employees: 154000,
        city: "Cupertino",
        website: "https://www.apple.com",
        logoUrl: nil
    )

    let microsoftDetails = AssetDetails(
        ticker: "MSFT",
        name: "Microsoft Corp",
        description: "Microsoft develops and licenses consumer and enterprise software. It is known for its Windows operating systems and Office productivity suite. The company is organized into three equally sized broad segments: productivity and business processes, intelligence cloud, and more personal computing.",
        marketCap: 2978716847546,
        employees: 228000,
        city: "Redmond",
        website: "https://www.microsoft.com",
        logoUrl: nil
    )
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                headerSection
                
                // Chart
                chartSection
                
                // Key Stats
                statsGrid
                
                // About
                aboutSection
            }
            .padding(16)
        }
        .background(Color.screenBackground.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(asset.ticker)
                    .customFont(.title3)
                    .foregroundStyle(Color.textSecondary)
                    .bold()
                Text(asset.name)
                    .customFont(.title2)
                    .bold()
                    .foregroundStyle(Color.textPrimary)
            }
            Spacer()
            Circle()
                .fill(Color.cardBackgroundSecondary)
                .frame(width: 48, height: 48)
                .overlay(Image(systemName: asset.logoUrl ?? "building.columns.fill").foregroundStyle(Color.textPrimary))
        }
    }
    
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    Text("$189.42")
                        .customFont(.largeTitle)
                        .bold()
                        .foregroundStyle(Color.textPrimary)
                    Text("+1.24% today")
                        .customFont(.body)
                        .foregroundStyle(Color.accentGreen)
                }
                Spacer()
            }
            
            Chart {
                ForEach(dummyPerformanceData) { data in
                    LineMark(
                        x: .value("Date", data.date),
                        y: .value("Price", data.value)
                    )
                    .foregroundStyle(Color.blue)
                    .interpolationMethod(.catmullRom)
                    
                    AreaMark(
                        x: .value("Date", data.date),
                        y: .value("Price", data.value)
                    )
                    .foregroundStyle(LinearGradient(colors: [.blue.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom))
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(height: 220)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            
            // Time Range Selector
            HStack {
                ForEach(["1D", "1W", "1M", "1Y", "ALL"], id: \.self) { range in
                    Button {
                        selectedTimeRange = range
                    } label: {
                        Text(range)
                            .customFont(.caption)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(selectedTimeRange == range ? Color.blue : Color.clear, in: Capsule())
                            .foregroundStyle(selectedTimeRange == range ? .white : Color.textSecondary)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 20))
    }
    
    private var statsGrid: some View {
        let details = asset.ticker == "MSFT" ? microsoftDetails : appleDetails
        
        return LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            AssetStatCard(title: "Market Cap", value: formatMarketCap(details.marketCap))
            AssetStatCard(title: "Employees", value: "\(details.employees ?? 0)")
            AssetStatCard(title: "City", value: details.city ?? "N/A")
            AssetStatCard(title: "CEO", value: "N/A") // Not in JSON
        }
    }
    
    private func formatMarketCap(_ value: Double) -> String {
        if value >= 1_000_000_000_000 {
            return String(format: "$%.2fT", value / 1_000_000_000_000)
        } else if value >= 1_000_000_000 {
            return String(format: "$%.2fB", value / 1_000_000_000)
        }
        return "$\(Int(value))"
    }
    
    private var aboutSection: some View {
        let details = asset.ticker == "MSFT" ? microsoftDetails : appleDetails
        
        return VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .customFont(.headline)
                .foregroundStyle(Color.textPrimary)
            
            Text(details.description)
                .customFont(.body)
                .foregroundStyle(Color.textSecondary)
                .lineSpacing(4)
        }
        .padding(16)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 20))
    }
}

struct AssetStatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .customFont(.caption)
                .foregroundStyle(Color.textSecondary)
            Text(value)
                .customFont(.headline)
                .foregroundStyle(Color.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    NavigationStack {
        AssetDetailsView(asset: AssetSearchResult(ticker: "AAPL", name: "Apple Inc.", type: "Stock", logoUrl: "apple.logo"))
    }
}
