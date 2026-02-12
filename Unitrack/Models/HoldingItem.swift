//
//  HoldingItem.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import Foundation

struct HoldingItem: Identifiable, Codable {
    let id: String
    let portfolioId: String?
    let name: String
    let source: String?
    let value: Double
    let price: Double?
    let currentPrice: Double?
    let costBasis: Double?
    let quantity: Double?
    let ticker: String?
    let change24h: Double?
    let isPositive: Bool?
    let icon: String?
    
    init(id: String, portfolioId: String? = nil, name: String, source: String? = nil, value: Double, price: Double? = nil, currentPrice: Double? = nil, costBasis: Double? = nil, quantity: Double? = nil, ticker: String? = nil, change24h: Double? = nil, isPositive: Bool? = nil, icon: String? = nil) {
        self.id = id
        self.portfolioId = portfolioId
        self.name = name
        self.source = source
        self.value = value
        self.price = price
        self.currentPrice = currentPrice
        self.costBasis = costBasis
        self.quantity = quantity
        self.ticker = ticker
        self.change24h = change24h
        self.isPositive = isPositive
        self.icon = icon
    }
    
    var valueString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: value)) ?? "$\(value)"
    }
    
    var changeString: String {
        guard let change = change24h else { return "0.00%" }
        let sign = change >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.2f", change))%"
    }
}
