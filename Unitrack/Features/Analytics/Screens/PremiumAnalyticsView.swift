//
//  PremiumAnalyticsView.swift
//  Unitrack
//

import SwiftUI
import Charts

struct PremiumAnalyticsView: View {
    @State private var selectedTimeRange = 3 // Index for 1Y
    let timeRanges = ["1W", "1M", "6M", "1Y", "ALL"]
    
    @State private var health: HealthResponse?
    @State private var exposure: [RegionExposure] = []
    @State private var manualPortfolios: [Portfolio] = []
    @State private var projections: [String: AmortizationResponse] = [:]
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 1. Unitrack AI Header Card
                aiAuditCard
                
                // 2. Historical Performance Chart
                historicalPerformanceCard
                
                // 3. Benchmarking vs S&P 500
                benchmarkingCard
                
                // 4. Advanced Diversification
                diversificationSection
                
                // 5. Watchlist Performance
                watchlistSection
                
                // 6. Manual Asset Projections
                amortizationSection
            }
            .padding(16)
        }
        .background(Color.screenBackground.ignoresSafeArea())
        .onAppear {
            Task { await fetchData() }
        }
    }
    
    private func fetchData() async {
        isLoading = true
        do {
            async let healthTask = AnalyticsService.shared.getHealth()
            async let exposureTask = AnalyticsService.shared.getExposure()
            async let portfoliosTask = PortfolioService.shared.getPortfolios()
            
            let (healthRes, exposureRes, portfoliosRes) = try await (healthTask, exposureTask, portfoliosTask)
            
            let manualOnes = portfoliosRes.filter { $0.type == "MANUAL" }
            
            await MainActor.run {
                self.health = healthRes
                self.exposure = exposureRes
                self.manualPortfolios = manualOnes
            }
            
            // Fetch projections for manual portfolios
            for portfolio in manualOnes {
                if let proj = try? await AnalyticsService.shared.getAmortization(id: portfolio.id) {
                    await MainActor.run {
                        self.projections[portfolio.id] = proj
                    }
                }
            }
            
            await MainActor.run {
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to load analytics"
                self.isLoading = false
            }
        }
    }
    
    private var aiAuditCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label("Unitrack AI Audit", systemImage: "sparkles")
                    .customFont(.headline)
                    .foregroundStyle(.purple)
                
                Spacer()
                
                CircularHealthProgress(progress: Double(health?.score ?? 0) / 100.0)
                    .frame(width: 44, height: 44)
            }
            
            Text(health?.status ?? "Analyzing...")
                .customFont(.caption)
                .foregroundStyle(Color.textSecondary)
            
            Text(health?.summary ?? "Gathering insights for your portfolio...")
                .customFont(.body)
                .foregroundStyle(Color.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack {
                Text("Health Score: \(health?.score ?? 0)/100")
                    .customFont(.caption2)
                    .foregroundStyle(Color.textSecondary)
                
                Spacer()
                
                Button("Full Health Report") {
                    // Action
                }
                .font(.custom("Outfit-Regular", size: 12)) 
                .foregroundStyle(.blue)
            }
        }
        .padding(16)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(LinearGradient(colors: [.purple.opacity(0.3), .blue.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
        )
    }
    
    private var historicalPerformanceCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Performance")
                .customFont(.title3)
                .foregroundStyle(Color.textPrimary)
            
            Chart {
                ForEach(dummyPerformanceData) { data in
                    LineMark(
                        x: .value("Date", data.date),
                        y: .value("Value", data.value)
                    )
                    .foregroundStyle(LinearGradient(colors: [.green, .blue], startPoint: .leading, endPoint: .trailing))
                    .interpolationMethod(.catmullRom)
                    
                    AreaMark(
                        x: .value("Date", data.date),
                        y: .value("Value", data.value)
                    )
                    .foregroundStyle(LinearGradient(colors: [.green.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom))
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(height: 180)
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine().foregroundStyle(Color.textSecondary.opacity(0.1))
                    AxisValueLabel().foregroundStyle(Color.textSecondary)
                }
            }
            
            Picker("Time Range", selection: $selectedTimeRange) {
                ForEach(0..<timeRanges.count, id: \.self) { index in
                    Text(timeRanges[index]).tag(index)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding(16)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 20))
    }
    
    private var benchmarkingCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Benchmarking vs S&P 500")
                .customFont(.headline)
                .foregroundStyle(Color.textPrimary)
            
            Chart {
                ForEach(dummyPerformanceData) { data in
                    LineMark(
                        x: .value("Date", data.date),
                        y: .value("Value", data.value)
                    )
                    .foregroundStyle(.blue)
                    .interpolationMethod(.catmullRom)
                }
                
                ForEach(dummyBenchmarkData) { data in
                    LineMark(
                        x: .value("Date", data.date),
                        y: .value("Value", data.value)
                    )
                    .foregroundStyle(Color.textSecondary)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(height: 150)
            .chartXAxis(.hidden)
            .chartLegend {
                HStack(spacing: 16) {
                    Label("My Portfolio", systemImage: "circle.fill").foregroundStyle(.blue)
                    Label("S&P 500", systemImage: "circle.fill").foregroundStyle(Color.textSecondary)
                }
                .font(.caption2)
            }
        }
        .padding(16)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 20))
    }
    
    private var diversificationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Geographic Exposure")
                .customFont(.headline)
                .foregroundStyle(Color.textPrimary)
            
            HStack(spacing: 20) {
                if exposure.isEmpty {
                    Text("No exposure data available")
                        .customFont(.caption)
                        .foregroundStyle(Color.textSecondary)
                } else {
                    Chart(exposure) { region in
                        BarMark(
                            x: .value("Value", region.value),
                            stacking: .normalized
                        )
                        .foregroundStyle(by: .value("Region", region.region))
                        .cornerRadius(4)
                    }
                    .frame(height: 44)
                    .chartLegend(.hidden)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(exposure.prefix(3)) { region in
                            HStack(spacing: 8) {
                                Circle().fill(region.region == "North America" ? .blue : (region.region.contains("Crypto") ? .purple : .green)).frame(width: 8, height: 8)
                                Text(region.region).customFont(.caption).foregroundStyle(Color.textPrimary)
                                Spacer()
                                Text("\(Int(region.percentage))%").customFont(.caption).foregroundStyle(Color.textSecondary)
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 20))
    }
    
    private var watchlistSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Watchlist Alerts")
                .customFont(.headline)
                .foregroundStyle(Color.textPrimary)
            
            ForEach(0..<2) { _ in
                HStack {
                    Image(systemName: "pencil.circle.fill") // Placeholder using SF Symbol for now
                        .resizable()
                        .frame(width: 32, height: 32)
                        .background(Color.textSecondary.opacity(0.1))
                        .clipShape(Circle())
                        .foregroundStyle(Color.textPrimary)
                    
                    VStack(alignment: .leading) {
                        Text("AAPL").customFont(.headline).foregroundStyle(Color.textPrimary)
                        Text("Apple Inc.").customFont(.caption).foregroundStyle(Color.textSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("$189.42").customFont(.headline).foregroundStyle(Color.textPrimary)
                        Text("+2.4%").customFont(.caption).foregroundStyle(.green)
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .padding(16)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 20))
    }

    private var amortizationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Asset Projections")
                .customFont(.headline)
                .foregroundStyle(Color.textPrimary)
            
            if manualPortfolios.isEmpty {
                Text("Add a manual asset to see 12-month projections.")
                    .customFont(.caption)
                    .foregroundStyle(Color.textSecondary)
                    .padding(.vertical, 8)
            } else {
                ForEach(manualPortfolios) { portfolio in
                    if let projection = projections[portfolio.id] {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(projection.assetName)
                                    .customFont(.subheadline)
                                    .bold()
                                    .foregroundStyle(Color.textPrimary)
                                
                                Spacer()
                                
                                Text(projection.projectionType)
                                    .customFont(.caption2)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(projection.projectionType == "Appreciation" ? Color.green.opacity(0.1) : Color.red.opacity(0.1), in: Capsule())
                                    .foregroundStyle(projection.projectionType == "Appreciation" ? .green : .red)
                            }
                            
                            Chart {
                                ForEach(projection.projection, id: \.month) { item in
                                    LineMark(
                                        x: .value("Month", item.month),
                                        y: .value("Value", item.value)
                                    )
                                    .foregroundStyle(projection.projectionType == "Appreciation" ? .green : .red)
                                }
                            }
                            .frame(height: 100)
                            .chartXAxis {
                                AxisMarks(values: projection.projection.map { $0.month }) { _ in
                                    AxisValueLabel().font(.system(size: 8))
                                }
                            }
                            
                            HStack {
                                Text("Monthly Rate: \(String(format: "%.1f", projection.monthlyRate))%")
                                    .customFont(.caption2)
                                    .foregroundStyle(Color.textSecondary)
                                
                                Spacer()
                                
                                let finalVal = projection.projection.last?.value ?? 0
                                Text("End of Year: \(finalVal.formatted(.currency(code: "USD")))")
                                    .customFont(.caption2)
                                    .bold()
                                    .foregroundStyle(Color.textPrimary)
                            }
                        }
                        .padding(12)
                        .background(Color.cardBackgroundSecondary, in: RoundedRectangle(cornerRadius: 16))
                    }
                }
            }
        }
        .padding(16)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 20))
    }
}

// MARK: - Components
struct CircularHealthProgress: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.textSecondary.opacity(0.2), lineWidth: 4)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    LinearGradient(colors: [.purple, .blue], startPoint: .top, endPoint: .bottom),
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(progress * 100))")
                .customFont(.caption)
                .bold()
                .foregroundStyle(Color.textPrimary)
        }
    }
}

// MARK: - Dummy Data Models
struct ChartPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

struct SectorData: Identifiable {
    let id = UUID()
    let name: String
    let value: Double
}

let dummyPerformanceData: [ChartPoint] = (0..<20).map { i in
    ChartPoint(date: Date().addingTimeInterval(TimeInterval(-i * 86400)), value: Double.random(in: 10000...15000))
}.reversed()

let dummyBenchmarkData: [ChartPoint] = (0..<20).map { i in
    ChartPoint(date: Date().addingTimeInterval(TimeInterval(-i * 86400)), value: Double.random(in: 11000...14000))
}.reversed()

let dummySectorData = [
    SectorData(name: "Tech", value: 42),
    SectorData(name: "Finance", value: 20),
    SectorData(name: "Health", value: 15),
    SectorData(name: "Other", value: 23)
]

#Preview {
    PremiumAnalyticsView()
}
