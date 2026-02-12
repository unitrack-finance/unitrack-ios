//
//  AssetDetails.swift
//  Unitrack
//
//  Created by Sylus Abel on 12/02/2026.
//

import Foundation

struct MarketSearchResult: Codable, Identifiable, Hashable, Equatable {
    var id: String { ticker }
    let ticker: String
    let name: String
    let type: String // Stock|Crypto
    let logoUrl: String?
}

struct AssetAddress: Codable, Hashable, Equatable {
    let address1: String?
    let city: String?
    let state: String?
    let postalCode: String?
}

struct AssetDetails: Codable, Hashable, Equatable {
    let ticker: String
    let name: String
    let price: Double?
    let marketCap: Double?
    let description: String?
    let type: String
    let logoUrl: String?
    let iconUrl: String?
    let homepageUrl: String?
    let market: String?
    let locale: String?
    let primaryExchange: String?
    let currencyName: String?
    let listDate: String?
    let address: AssetAddress?
    
    // Optional metrics that might not be in the detail payload but are used in UI
    let change: Double?
    let changePercent: Double?
}

struct MarketPriceResponse: Codable, Hashable, Equatable {
    let ticker: String
    let price: Double
    let type: String
}

struct MarketAggregateItem: Codable, Identifiable, Hashable, Equatable {
    var id: Int64 { t }
    let v: Double  // Volume
    let o: Double  // Open
    let c: Double  // Close
    let h: Double  // High
    let l: Double  // Low
    let t: Int64   // Timestamp
}

struct MarketAggregatesResponse: Codable, Hashable, Equatable {
    let ticker: String
    let aggregates: [MarketAggregateItem]
}
