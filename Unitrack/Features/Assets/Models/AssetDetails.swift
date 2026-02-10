//
//  AssetDetails.swift
//  Unitrack
//
//  Created by Sylus Abel on 10/02/2026.
//

import Foundation

struct AssetDetails: Codable, Identifiable {
    let id = UUID()
    let ticker: String
    let name: String
    let description: String
    let marketCap: Double
    let employees: Int?
    let city: String?
    let website: String?
    let logoUrl: String?
    
    // Custom initializer to map from specific JSON structure if needed
    // For now we will use a simpler internal model based on the user's JSON
}

struct AssetSearchResult: Identifiable, Hashable {
    let id = UUID()
    let ticker: String
    let name: String
    let type: String // "Stock" or "Crypto"
    let logoUrl: String?
}
