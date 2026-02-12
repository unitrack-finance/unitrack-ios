//
//  ManualAssetService.swift
//  Unitrack
//
//  Created by Sylus Abel on 12/02/2026.
//

import Foundation

struct CreateManualAssetPayload: Codable {
    let ticker: String
    let name: String
    let type: String
    let value: Double
    let currency: String?
    let date: String?
}

struct UpdateManualAssetPayload: Codable {
    let value: Double
    let date: String?
}

class ManualAssetService {
    static let shared = ManualAssetService()
    private let client = HTTPClient()
    
    private init() {}
    
    func createAsset(ticker: String, name: String, type: String, value: Double, currency: String? = "USD", date: Date? = nil) async throws {
        let url = Constants.URLs.assetsManual
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = date != nil ? formatter.string(from: date!) : nil
        
        let payload = CreateManualAssetPayload(
            ticker: ticker,
            name: name,
            type: type,
            value: value,
            currency: currency,
            date: dateString
        )
        try await client.postVoid(to: url, body: payload)
    }
    
    func listAssets() async throws -> [Portfolio] {
         return try await client.get(from: Constants.URLs.assetsManual)
    }
    
    func updateAsset(id: String, value: Double, date: Date = Date()) async throws {
        let url = Constants.URLs.assetsManual.appendingPathComponent(id)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        let payload = UpdateManualAssetPayload(value: value, date: dateString)
        try await client.putVoid(to: url, body: payload)
    }
    
    func deleteAsset(id: String) async throws {
        let url = Constants.URLs.assetsManual.appendingPathComponent(id)
        print("🗑️ Deleting Manual Asset with ID: \(id) at URL: \(url)")
        try await client.deleteVoid(from: url)
    }
}
