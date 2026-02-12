//
//  MarketService.swift
//  Unitrack
//
//  Created by Sylus Abel on 12/02/2026.
//

import Foundation

class MarketService {
    static let shared = MarketService()
    private let client = HTTPClient()
    
    private init() {}
    
    func search(query: String) async throws -> [MarketSearchResult] {
        let url = Constants.URLs.market.appendingPathComponent("search")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "q", value: query)]
        return try await client.get(from: components.url!)
    }
    
    func getAssetDetail(ticker: String) async throws -> AssetDetails {
        let url = Constants.URLs.market.appendingPathComponent("assets").appendingPathComponent(ticker)
        return try await client.get(from: url)
    }
    
    func getPrice(ticker: String, type: String? = nil) async throws -> MarketPriceResponse {
        var url = Constants.URLs.market.appendingPathComponent("assets").appendingPathComponent(ticker).appendingPathComponent("price")
        if let type = type {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            components.queryItems = [URLQueryItem(name: "type", value: type)]
            url = components.url!
        }
        return try await client.get(from: url)
    }
    
    func getAggregates(ticker: String, from: String, to: String, timespan: String = "day") async throws -> MarketAggregatesResponse {
        let url = Constants.URLs.market.appendingPathComponent("assets").appendingPathComponent(ticker).appendingPathComponent("aggregates")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "from", value: from),
            URLQueryItem(name: "to", value: to),
            URLQueryItem(name: "timespan", value: timespan)
        ]
        return try await client.get(from: components.url!)
    }
}
