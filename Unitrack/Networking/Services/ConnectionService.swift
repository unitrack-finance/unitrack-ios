//
//  ConnectionService.swift
//  Unitrack
//
//  Created by Sylus Abel on 12/02/2026.
//

import Foundation

struct PlaidExchangePayload: Codable {
    let publicToken: String
    let metadata: PlaidMetadata
}

struct PlaidMetadata: Codable {
    let institution: PlaidInstitution
}

struct PlaidInstitution: Codable {
    let name: String
    let institution_id: String
}

struct WalletConnectPayload: Codable {
    let address: String
    let label: String?
}

class ConnectionService {
    static let shared = ConnectionService()
    private let client = HTTPClient()
    
    private init() {}
    
    // MARK: - Plaid
    
    func getLinkToken() async throws -> String {
        let url = Constants.URLs.plaid.appendingPathComponent("link-token")
        struct Response: Codable { let linkToken: String }
        let response: Response = try await client.post(to: url, body: [String: String]())
        return response.linkToken
    }
    
    func exchangePublicToken(publicToken: String, institutionName: String, institutionId: String) async throws {
        let url = Constants.URLs.plaid.appendingPathComponent("exchange")
        let metadata = PlaidMetadata(institution: PlaidInstitution(name: institutionName, institution_id: institutionId))
        let payload = PlaidExchangePayload(publicToken: publicToken, metadata: metadata)
        _ = try await client.post(to: url, body: payload) as [String: String]
    }
    
    // MARK: - Wallet
    
    func connectWallet(address: String, label: String?) async throws -> Portfolio {
        let payload = WalletConnectPayload(address: address, label: label)
        return try await client.post(to: Constants.URLs.wallet, body: payload)
    }
    
    func syncWallet(id: String) async throws {
        let url = Constants.URLs.wallet.appendingPathComponent("sync").appendingPathComponent(id)
        _ = try await client.post(to: url, body: [String: String]()) as [String: String]
    }
}
