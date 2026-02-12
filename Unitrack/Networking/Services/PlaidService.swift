//
//  PlaidService.swift
//  Unitrack
//

import Foundation

struct LinkTokenResponse: Codable {
    let linkToken: String
}

struct ExchangeTokenRequest: Codable {
    let publicToken: String
    let institutionId: String?
    let accountIds: [String]
}

// Helper for dynamic metadata
struct AnyCodable: Codable {
    let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) { value = x }
        else if let x = try? container.decode(Int.self) { value = x }
        else if let x = try? container.decode(Double.self) { value = x }
        else if let x = try? container.decode(Bool.self) { value = x }
        else if let x = try? container.decode([String: AnyCodable].self) { value = x.mapValues { $0.value } }
        else if let x = try? container.decode([AnyCodable].self) { value = x.map { $0.value } }
        else { throw DecodingError.dataCorruptedError(in: container, debugDescription: "AnyCodable value cannot be decoded") }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let x = value as? String { try container.encode(x) }
        else if let x = value as? Int { try container.encode(x) }
        else if let x = value as? Double { try container.encode(x) }
        else if let x = value as? Bool { try container.encode(x) }
        else if let x = value as? [String: Any] { try container.encode(x.mapValues { AnyCodable($0) }) }
        else if let x = value as? [Any] { try container.encode(x.map { AnyCodable($0) }) }
        else { throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: [], debugDescription: "AnyCodable value cannot be encoded")) }
    }
}

class PlaidService {
    static let shared = PlaidService()
    private let client = HTTPClient()
    
    private init() {}
    
    func fetchLinkToken() async throws -> String {
        let url = Constants.URLs.plaid.appendingPathComponent("link-token")
        let response: LinkTokenResponse = try await client.post(to: url, body: [String: String]())
        return response.linkToken
    }
    
    func exchangePublicToken(publicToken: String, institutionId: String?, accountIds: [String]) async throws {
        let url = Constants.URLs.plaid.appendingPathComponent("exchange")
        let payload = ExchangeTokenRequest(publicToken: publicToken, institutionId: institutionId, accountIds: accountIds)
        try await client.postVoid(to: url, body: payload)
    }
}
