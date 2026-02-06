//
//  DashboardView.swift
//  Unitrack
//
//  Created by Sylus Abel on 05/02/2026.
//

import SwiftUI

// MARK: - Design System Colors
extension Color {
    static let cardBackground = Color(white: 0.11)
    static let cardBackgroundSecondary = Color(white: 0.15)
    static let accentGreen = Color(red: 0.7, green: 0.85, blue: 0.4)
    static let textPrimary = Color.white
    static let textSecondary = Color(white: 0.6)
    static let textTertiary = Color(white: 0.45)
}

struct DashboardView: View {
    @State private var isSyncing = false
    @State private var selectedTimeframe = "30 Days"

    private let allocation: [AllocationItem] = [
        .init(name: "Stocks", value: 46, color: Color(white: 0.85), source: .plaid),
        .init(name: "Crypto", value: 18, color: Color(white: 0.55), source: .manual),
        .init(name: "Real Estate", value: 14, color: Color(red: 0.55, green: 0.6, blue: 0.45), source: .manual),
        .init(name: "Fixed Income", value: 12, color: Color(red: 0.7, green: 0.75, blue: 0.55), source: .plaid),
        .init(name: "Cash", value: 10, color: Color(white: 0.35), source: .plaid)
    ]

    private let stats: [StatItem] = [
        .init(title: "Best Performer", subtitle: "AAPL", value: "+4.8%", icon: "arrow.up.right.circle.fill", isPositive: true),
        .init(title: "Worst Performer", subtitle: "ETH", value: "-2.1%", icon: "arrow.down.right.circle.fill", isPositive: false),
        .init(title: "Top Holding", subtitle: "VTI", value: "$18,420", icon: "star.circle.fill", isPositive: true),
        .init(title: "Connected Accounts", subtitle: "5 synced", value: "Verified", icon: "checkmark.seal.fill", isPositive: true)
    ]

    private let holdings: [HoldingItem] = [
        .init(name: "Vanguard Total Stock", source: "Fidelity", value: "$18,420", change: "+1.2%", isPositive: true, icon: "building.columns.fill"),
        .init(name: "Apple", source: "Robinhood", value: "$8,240", change: "+4.8%", isPositive: true, icon: "apple.logo"),
        .init(name: "Bitcoin", source: "Manual Entry", value: "$6,120", change: "-0.6%", isPositive: false, icon: "bitcoinsign.circle.fill"),
        .init(name: "Gold Bars", source: "Manual Entry", value: "$4,980", change: "+0.4%", isPositive: true, icon: "circle.grid.cross.fill"),
        .init(name: "US Treasury", source: "Schwab", value: "$3,110", change: "+0.1%", isPositive: true, icon: "chart.bar.fill")
    ]
    
    private let portfolios: [Portfolio] = [
        .init(name: "Metamask - ETH", balance: "$14,908"),
        .init(name: "Coinbase", balance: "$100,400"),
        .init(name: "Interactive Brokers", balance: "$14,500")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    headerSection
                    portfolioOverviewCard
                    syncStatusBanner
                    allocationSection
                    quickStatsSection
                    holdingsSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
            .scrollIndicators(.hidden)
        }
    }
}

// MARK: - View Components
private extension DashboardView {
    
    var headerSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hi, Sylus!")
                    .customFont(.title2)
                  
                Text(Date().formatted(.dateTime.day().month(.wide).year()))
                    .customFont(.caption)
                   
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                IconButton(icon: "gearshape", action: {})
                IconButton(icon: "bell", action: {})
                
                Circle()
                    .fill(Color.cardBackgroundSecondary)
                    .frame(width: 40, height: 40)
                    .overlay {
                        Image(systemName: "person.fill")
            
                    }
            }
        }
        .padding(.vertical, 8)
    }
    
    var portfolioOverviewCard: some View {
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
            
            // Portfolio cards horizontal scroll
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

    var syncStatusBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: isSyncing ? "arrow.triangle.2.circlepath.circle.fill" : "checkmark.seal.fill")
                .font(.title3)
                .foregroundStyle(isSyncing ? .orange : .accentGreen)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(isSyncing ? "Syncing with Fidelity…" : "All accounts up to date")
                    .customFont(.subheadline)
                    
                Text(isSyncing ? "Updating holdings" : "Last sync 2 hours ago")
                    .customFont(.caption)
                   
            }
            
            Spacer()
            
            if isSyncing {
                ProgressView()
                    .tint(.textSecondary)
            } else {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) { isSyncing.toggle() }
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.subheadline)
                        
                }
            }
        }
        .padding(16)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    var allocationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Portfolio Allocation")
                    .customFont(.headline)
                   
                Spacer()
                NavigationArrowButton(action: {})
            }

            HStack(spacing: 20) {
                AllocationRingView(items: allocation)
                    .frame(width: 120, height: 120)

                VStack(alignment: .leading, spacing: 10) {
                    ForEach(allocation) { item in
                        HStack(spacing: 10) {
                            Circle()
                                .fill(item.color)
                                .frame(width: 8, height: 8)
                            Text(item.name)
                                .customFont(.caption)
                                .foregroundStyle(Color.textSecondary)
                            Spacer()
                            Text("\(item.value)%")
                                .customFont(.caption)
                                .foregroundStyle(Color.textPrimary)
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Quick Stats")
                    .customFont(.headline)
                  
                Spacer()
                NavigationArrowButton(action: {})
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(stats) { item in
                        StatCard(item: item)
                    }
                }
            }
        }
    }

    var holdingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Top Holdings")
                    .customFont(.headline)
                    
                Spacer()
                Button("View All") {}
                    .customFont(.caption)
                   
            }

            VStack(spacing: 10) {
                ForEach(holdings) { holding in
                    HoldingRow(item: holding)
                }
            }
        }
    }
}

// MARK: - Data Models
private struct AllocationItem: Identifiable {
    let id = UUID()
    let name: String
    let value: Int
    let color: Color
    let source: DataSource
}

private enum DataSource {
    case plaid
    case manual
}

private struct StatItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let value: String
    let icon: String
    let isPositive: Bool
}

private struct HoldingItem: Identifiable {
    let id = UUID()
    let name: String
    let source: String
    let value: String
    let change: String
    let isPositive: Bool
    let icon: String
}

private struct Portfolio: Identifiable {
    let id = UUID()
    let name: String
    let balance: String
}

// MARK: - Reusable Components
private struct IconButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(Color.textSecondary)
                .frame(width: 40, height: 40)
                .background(Color.cardBackgroundSecondary, in: Circle())
        }
    }
}

private struct NavigationArrowButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.up.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.black)
                .frame(width: 32, height: 32)
                .background(Color.white, in: Circle())
        }
    }
}

private struct ChangeIndicator: View {
    let value: String
    let percentage: String
    let isPositive: Bool
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                .font(.caption2.weight(.bold))
            Text(value)
                .customFont(.caption)
            Text(percentage)
                .customFont(.caption)
        }
        .foregroundStyle(isPositive ? Color.accentGreen : Color.red)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(isPositive ? Color.accentGreen.opacity(0.1) : Color.red.opacity(0.15))
        )
    }
}

private struct MiniPortfolioCard: View {
    let portfolio: Portfolio
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "arrow.up.right")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.black)
                    .frame(width: 24, height: 24)
                    .background(Color.white, in: Circle())
                Spacer()
            }
            
            Spacer()
            
            Text(portfolio.balance)
                .customFont(.headline)
                .foregroundStyle(Color.textPrimary)
            
            Text(portfolio.name)
                .customFont(.caption)
                .foregroundStyle(Color.textSecondary)
                .lineLimit(1)
        }
        .padding(14)
        .frame(width: 140, height: 120)
        .background(Color.cardBackgroundSecondary, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct AllocationRingView: View {
    let items: [AllocationItem]

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(white: 0.2), lineWidth: 16)

            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                CircleSegment(start: startAngle(for: index), end: endAngle(for: index))
                    .stroke(item.color, style: StrokeStyle(lineWidth: 16, lineCap: .round))
            }

            VStack(spacing: 2) {
                Text("Total")
                    .customFont(.caption2)
                    .foregroundStyle(Color.textTertiary)
                Text("100%")
                    .customFont(.headline)
                    .foregroundStyle(Color.textPrimary)
            }
        }
    }

    private func startAngle(for index: Int) -> Angle {
        let value = items.prefix(index).reduce(0) { $0 + $1.value }
        return Angle(degrees: Double(value) / 100 * 360 - 90)
    }

    private func endAngle(for index: Int) -> Angle {
        let value = items.prefix(index + 1).reduce(0) { $0 + $1.value }
        return Angle(degrees: Double(value) / 100 * 360 - 90)
    }
}

private struct CircleSegment: Shape {
    let start: Angle
    let end: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: start, endAngle: end, clockwise: false)
        return path
    }
}

private struct StatCard: View {
    let item: StatItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: item.icon)
                .font(.title3)
                .foregroundStyle(item.isPositive ? .pink : .red)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .customFont(.caption)
                    .foregroundStyle(Color.textSecondary)
                Text(item.subtitle)
                    .customFont(.subheadline)
                    .foregroundStyle(Color.textPrimary)
            }
            
            Text(item.value)
                .customFont(.headline)
                .foregroundStyle(item.isPositive ? Color.accentGreen : Color.red)
        }
        .padding(16)
        .frame(width: 150, alignment: .leading)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

private struct HoldingRow: View {
    let item: HoldingItem

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: item.icon)
                .font(.body)
                .foregroundStyle(Color.textPrimary)
                .frame(width: 40, height: 40)
                .background(Color.cardBackgroundSecondary, in: RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 3) {
                Text(item.name)
                    .customFont(.subheadline)
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(1)
                Text(item.source)
                    .customFont(.caption)
                    .foregroundStyle(Color.textTertiary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 3) {
                Text(item.value)
                    .customFont(.subheadline)
                    .foregroundStyle(Color.textPrimary)
                Text(item.change)
                    .customFont(.caption)
                    .foregroundStyle(item.isPositive ? Color.accentGreen : Color.red)
            }
        }
        .padding(14)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct PortfolioDetailView: View {
    let portfolio: Portfolio

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Balance")
                .customFont(.caption)
                .foregroundStyle(Color.textSecondary)
            Text(portfolio.balance)
                .customFont(.largeTitle)
                .foregroundStyle(Color.textPrimary)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color.black)
        .navigationTitle(portfolio.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DashboardView()
        .preferredColorScheme(.dark)
}
