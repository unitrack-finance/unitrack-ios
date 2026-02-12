//
//  PortfolioService.swift
//  Unitrack
//
//  Created by Sylus Abel on 12/02/2026.
//

import Foundation

class PortfolioService {
    static let shared = PortfolioService()
    private let client = HTTPClient()
    
    private init() {}
    
    func getPortfolios() async throws -> [Portfolio] {
        return try await client.get(from: Constants.URLs.portfolio)
    }
    
    func getPortfolioDetail(id: String) async throws -> Portfolio {
        let url = Constants.URLs.portfolio.appendingPathComponent(id)
        return try await client.get(from: url)
    }
    
    func getSummary() async throws -> PortfolioSummary {
        let url = Constants.URLs.portfolio.appendingPathComponent("summary")
        return try await client.get(from: url)
    }
    
    func getHoldings() async throws -> [HoldingItem] {
        let url = Constants.URLs.portfolio.appendingPathComponent("holdings")
        return try await client.get(from: url)
    }
    
    func getHistory() async throws -> [HistoryResponseItem] {
        let url = Constants.URLs.portfolio.appendingPathComponent("history")
        return try await client.get(from: url)
    }
    
    func getAllocation() async throws -> [AllocationResponseItem] {
        let url = Constants.URLs.portfolio.appendingPathComponent("allocation")
        return try await client.get(from: url)
    }
    
    func createPortfolio(name: String, type: String = "MANUAL") async throws -> Portfolio {
        let payload = ["name": name, "type": type]
        return try await client.post(to: Constants.URLs.portfolio, body: payload)
    }
}
