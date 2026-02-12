//
//  AnalyticsService.swift
//  Unitrack
//
//  Created by Sylus Abel on 12/02/2026.
//

import Foundation

struct HealthResponse: Codable {
    let score: Int
    let status: String
    let summary: String
}

struct ChatRequest: Codable {
    let message: String
}

struct ChatResponse: Codable {
    let response: String
}

struct RegionExposure: Codable, Identifiable {
    var id: String { region }
    let region: String
    let value: Double
    let percentage: Double
}

struct AmortizationProjection: Codable {
    let month: String
    let value: Double
}

struct AmortizationResponse: Codable {
    let assetName: String
    let currentValue: Double
    let projectionType: String
    let monthlyRate: Double
    let projection: [AmortizationProjection]
}

class AnalyticsService {
    static let shared = AnalyticsService()
    private let client = HTTPClient()
    
    private init() {}
    
    func getHealth() async throws -> HealthResponse {
        let url = Constants.URLs.analytics.appendingPathComponent("health")
        return try await client.get(from: url)
    }
    
    func getExposure() async throws -> [RegionExposure] {
        let url = Constants.URLs.analytics.appendingPathComponent("exposure")
        return try await client.get(from: url)
    }
    
    func getAmortization(id: String) async throws -> AmortizationResponse {
        let url = Constants.URLs.analytics.appendingPathComponent("amortization").appendingPathComponent(id)
        return try await client.get(from: url)
    }
    
    func chat(message: String) async throws -> String {
        let url = Constants.URLs.analytics.appendingPathComponent("chat")
        let payload = ChatRequest(message: message)
        let response: ChatResponse = try await client.post(to: url, body: payload)
        return response.response
    }
}
