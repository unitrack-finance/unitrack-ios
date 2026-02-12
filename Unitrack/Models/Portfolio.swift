//
//  Portfolio.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import Foundation

struct Snapshot: Codable {
    let date: String
    let value: Double
}

struct Portfolio: Identifiable, Codable {
    let id: String
    let name: String
    let type: String // PLAID|WALLET|MANUAL
    let totalValue: Double
    let status: String? // ACTIVE|NEEDS_REAUTH
    let lastSynced: String?
    let createdAt: String?
    let updatedAt: String?
    let holdings: [HoldingItem]?
    let snapshots: [Snapshot]?
    
    var balanceFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: totalValue)) ?? "$\(totalValue)"
    }
}

struct PortfolioSummary: Codable {
    let totalValue: Double
    let currency: String
    let change24h: Double
    let changePercent24h: Double
    let lastUpdated: String
}

struct AllocationResponseItem: Codable {
    let category: String
    let value: Double
    let percentage: Double
}

struct HistoryResponseItem: Codable {
    let date: String
    let value: Double
}
