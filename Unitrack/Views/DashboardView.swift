//
//  DashboardView.swift
//  Unitrack
//
//  Created by Sylus Abel on 05/02/2026.
//

import SwiftUI

struct DashboardView: View {
    @State private var isSyncing = false

    private let allocation: [AllocationItem] = [
        .init(name: "Stocks", value: 46, color: .blue, source: .plaid),
        .init(name: "Crypto", value: 18, color: .purple, source: .manual),
        .init(name: "Real Estate", value: 14, color: .orange, source: .manual),
        .init(name: "Fixed Income", value: 12, color: .green, source: .plaid),
        .init(name: "Cash", value: 10, color: .gray, source: .plaid)
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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    syncStatusBanner
                    allocationSection
                    quickStatsSection
                    holdingsSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 32)
            }
            .navigationTitle("Dashboard")
            .toolbar {
                Button {
                    withAnimation { isSyncing.toggle() }
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                }
                .accessibilityLabel("Sync accounts")
            }
        }
    }
}

private extension DashboardView {
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Total Portfolio")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("$128,540")
                        .font(.largeTitle.bold())
                    HStack(spacing: 6) {
                        Text("+$1,240 (0.97%)")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.green)
                        Text("24h")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 6) {
                    Label("Powered by Plaid", systemImage: "link.circle.fill")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.blue)
                    Text("Last sync 2h ago")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var syncStatusBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: isSyncing ? "arrow.triangle.2.circlepath.circle.fill" : "checkmark.seal.fill")
                .foregroundStyle(isSyncing ? .orange : .green)
            VStack(alignment: .leading, spacing: 4) {
                Text(isSyncing ? "Syncing with Fidelity…" : "All accounts up to date")
                    .font(.subheadline.weight(.semibold))
                Text(isSyncing ? "Updating holdings" : "Last successful sync 2 hours ago")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if isSyncing {
                ProgressView()
            }
        }
        .padding(12)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    var allocationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Portfolio Allocation")
                    .font(.headline)
                Spacer()
                Button("View") {}
                    .font(.caption.weight(.semibold))
            }

            HStack(spacing: 16) {
                AllocationRingView(items: allocation)
                    .frame(width: 140, height: 140)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(allocation) { item in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(item.color)
                                .frame(width: 10, height: 10)
                            Text(item.name)
                                .font(.subheadline)
                            Spacer()
                            Text("\(item.value)%")
                                .font(.subheadline.weight(.semibold))
                            Image(systemName: item.source == .plaid ? "link.circle.fill" : "pencil.circle.fill")
                                .foregroundStyle(item.source == .plaid ? .blue : .secondary)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Stats")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(stats) { item in
                        StatCard(item: item)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var holdingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Top Holdings")
                    .font(.headline)
                Spacer()
                Button("View All Accounts") {}
                    .font(.caption.weight(.semibold))
            }

            VStack(spacing: 12) {
                ForEach(holdings) { holding in
                    HoldingRow(item: holding)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

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

private struct AllocationRingView: View {
    let items: [AllocationItem]

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 18)

            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                CircleSegment(start: startAngle(for: index), end: endAngle(for: index))
                    .stroke(item.color, style: StrokeStyle(lineWidth: 18, lineCap: .round))
            }

            VStack(spacing: 4) {
                Text("Allocation")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("100%")
                    .font(.headline)
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
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: item.icon)
                .font(.title2)
                .foregroundStyle(item.isPositive ? .green : .red)
            Text(item.title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(item.subtitle)
                .font(.subheadline.weight(.semibold))
            Text(item.value)
                .font(.headline)
                .foregroundStyle(item.isPositive ? .green : .red)
        }
        .padding(14)
        .frame(width: 160, alignment: .leading)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct HoldingRow: View {
    let item: HoldingItem

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: item.icon)
                .font(.title3)
                .foregroundStyle(.blue)
                .frame(width: 36, height: 36)
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 10, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.subheadline.weight(.semibold))
                Text(item.source)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(item.value)
                    .font(.subheadline.weight(.semibold))
                Text(item.change)
                    .font(.caption)
                    .foregroundStyle(item.isPositive ? .green : .red)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    DashboardView()
}
