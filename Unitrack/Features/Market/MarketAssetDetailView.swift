//
//  MarketAssetDetailView.swift
//  Unitrack
//
//  Created by Sylus Abel on 12/02/2026.
//

import SwiftUI
import Charts

struct MarketAssetDetailView: View {
    let ticker: String
    @State private var assetDetail: AssetDetails?
    @State private var price: MarketPriceResponse?
    @State private var aggregates: MarketAggregatesResponse?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 300)
                } else if let errorMessage = errorMessage {
                     VStack(spacing: 16) {
                         Image(systemName: "exclamationmark.triangle")
                             .customFont(.largeTitle)
                             .foregroundStyle(.red)
                         Text(errorMessage)
                             .multilineTextAlignment(.center)
                     }
                     .frame(maxWidth: .infinity, minHeight: 300)
                } else {
                    headerSection
                    chartSection
                    metricsSection
                    if let description = assetDetail?.description {
                        aboutSection(description)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(ticker)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadData()
        }
    }
    
    private var headerSection: some View {
        HStack(alignment: .center, spacing: 16) {
            let iconUrl = assetDetail?.iconUrl ?? assetDetail?.logoUrl
            if let urlStr = iconUrl, let url = URL(string: urlStr) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Circle().fill(Color.gray.opacity(0.1))
                }
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(assetDetail?.name ?? ticker)
                    .customFont(.title2)
                    .bold()
                Text(ticker)
                    .customFont(.headline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "$%.2f", price?.price ?? assetDetail?.price ?? 0.0))
                    .customFont(.title3)
                    .bold()
                
                if let changePct = assetDetail?.changePercent {
                    Text(String(format: "%@%.2f%%", changePct >= 0 ? "+" : "", changePct))
                        .customFont(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(changePct >= 0 ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                        .foregroundStyle(changePct >= 0 ? .green : .red)
                        .clipShape(Capsule())
                }
            }
        }
    }
    
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Price History (Last 30 Days)")
                .customFont(.headline)
            
            if let items = aggregates?.aggregates, !items.isEmpty {
                Chart(items) { item in
                    LineMark(
                        x: .value("Time", Date(timeIntervalSince1970: TimeInterval(item.t / 1000))),
                        y: .value("Price", item.c)
                    )
                    .foregroundStyle(Color.purple)
                }
                .frame(height: 250)
                .chartYScale(domain: .automatic)
            } else {
                Text("No chart data available")
                    .customFont(.caption)
                    .frame(height: 250)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    private var metricsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Key Metrics")
                .customFont(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                MetricCard(title: "Market Cap", value: formatLargeNumber(assetDetail?.marketCap))
                MetricCard(title: "Exchange", value: assetDetail?.primaryExchange ?? "--")
                MetricCard(title: "Currency", value: assetDetail?.currencyName?.uppercased() ?? "USD")
                MetricCard(title: "List Date", value: assetDetail?.listDate ?? "--")
            }
            
            if let address = assetDetail?.address {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Headquarters")
                        .customFont(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(address.address1 ?? "")\n\(address.city ?? ""), \(address.state ?? "") \(address.postalCode ?? "")")
                        .font(.subheadline)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    private func aboutSection(_ text: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About \(assetDetail?.name ?? ticker)")
                .font(.headline)
            Text(text)
                .customFont(.body)
                .foregroundStyle(.secondary)
        }
    }
    
    private func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let detail = MarketService.shared.getAssetDetail(ticker: ticker)
            async let currentPrice = MarketService.shared.getPrice(ticker: ticker)
            
            let to = Int64(Date().timeIntervalSince1970 * 1000)
            let from = Int64(Calendar.current.date(byAdding: .day, value: -30, to: Date())!.timeIntervalSince1970 * 1000)
            async let history = MarketService.shared.getAggregates(ticker: ticker, from: "\(from)", to: "\(to)")
            
            let resDetail = try await detail
            self.assetDetail = resDetail
            self.price = try? await currentPrice
            self.aggregates = try? await history
            
        } catch {
            self.errorMessage = error.userFriendlyMessage
        }
        
        isLoading = false
    }
    
    private func formatLargeNumber(_ num: Double?) -> String {
        guard let num = num else { return "--" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        if num >= 1_000_000_000_000 {
            return (formatter.string(from: NSNumber(value: num / 1_000_000_000_000)) ?? "") + "T"
        } else if num >= 1_000_000_000 {
            return (formatter.string(from: NSNumber(value: num / 1_000_000_000)) ?? "") + "B"
        } else if num >= 1_000_000 {
            return (formatter.string(from: NSNumber(value: num / 1_000_000)) ?? "") + "M"
        }
        return formatter.string(from: NSNumber(value: num)) ?? "--"
    }
}

private struct MetricCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .customFont(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .customFont(.subheadline)
                .bold()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack {
        MarketAssetDetailView(ticker: "BTC")
    }
}
