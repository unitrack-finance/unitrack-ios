//
//  PortfolioType.swift
//  Unitrack
//
//  Created by Sylus Abel on 09/02/2026.
//

import SwiftUI

enum PortfolioType: CaseIterable {
    case investments
    case cash
    case liabilities
    
    var title: String {
        switch self {
        case .investments:
            return "Investments"
        case .cash:
            return "Cash"
        case .liabilities:
            return "Liabilities"
        }
    }
    
    var description: String {
        switch self {
        case .investments:
            return "Import brokerage accounts, crypto wallets & exchanges etc."
        case .cash:
            return "Current accounts, savings account etc."
        case .liabilities:
            return "Credit cards, Loans, Mortgage etc."
        }
    }
    
    var icon: String {
        switch self {
        case .investments:
            return "chart.line.uptrend.xyaxis"
        case .cash:
            return "banknote"
        case .liabilities:
            return "creditcard"
        }
    }
    
    var accentColor: Color {
        switch self {
        case .investments:
            return .blue
        case .cash:
            return .green
        case .liabilities:
            return .orange
        }
    }
}
