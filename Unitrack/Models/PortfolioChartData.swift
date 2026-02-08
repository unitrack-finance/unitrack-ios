//
//  PortfolioChartData.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import Foundation

struct PortfolioChartData: Identifiable {
    let id = UUID()
    let value: Double
    let date: Date
    let open: Double
    let close: Double
    let high: Double
    let low: Double
    let volume: Double
}
