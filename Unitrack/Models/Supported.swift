//
//  Supported.swift
//  Unitrack
//
//  Created by Sylus Abel on 10/02/2026.
//

import Foundation

struct Connectable: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let url: String
    let logoUrl: String
    let type: ConnectionType
}

enum ConnectionType: String, CaseIterable, Hashable {
    case broker = "Brokers"
    case exchange = "Exchanges"
    case wallet = "Wallets"
}

struct Supported {
    static let brokers: [Connectable] = [
        .init(name: "Interactive Brokers", url: "https://www.interactivebrokers.com", logoUrl: "chart.bar.fill", type: .broker), // SF Symbol placeholder
        .init(name: "Robinhood", url: "https://robinhood.com", logoUrl: "arrow.up.arrow.down", type: .broker),
        .init(name: "Trading 212", url: "https://www.trading212.com", logoUrl: "building.columns.fill", type: .broker),
        .init(name: "Trade Republic", url: "https://traderepublic.com", logoUrl: "banknote.fill", type: .broker),
        .init(name: "DEGIRO", url: "https://www.degiro.ie", logoUrl: "d.circle.fill", type: .broker),
        .init(name: "Fidelity", url: "https://www.fidelity.com", logoUrl: "f.circle.fill", type: .broker),
        .init(name: "Vanguard", url: "https://investor.vanguard.com", logoUrl: "v.circle.fill", type: .broker)
    ]
    
    static let exchanges: [Connectable] = [
        .init(name: "Coinbase", url: "https://www.coinbase.com", logoUrl: "bitcoinsign.circle.fill", type: .exchange),
        .init(name: "Binance", url: "https://www.binance.com", logoUrl: "b.circle.fill", type: .exchange),
        .init(name: "Kraken", url: "https://www.kraken.com", logoUrl: "k.circle.fill", type: .exchange),
        .init(name: "Gemini", url: "https://www.gemini.com", logoUrl: "g.circle.fill", type: .exchange),
        .init(name: "Crypto.com", url: "https://crypto.com", logoUrl: "c.circle.fill", type: .exchange)
    ]
    
    static let wallets: [Connectable] = [
        .init(name: "MetaMask", url: "https://metamask.io", logoUrl: "m.circle.fill", type: .wallet), // Using SF symbol for now, user likely wants real logos, but I'll use text/sf symbols until image assets are real
        .init(name: "Trust Wallet", url: "https://trustwallet.com", logoUrl: "shield.fill", type: .wallet),
        .init(name: "Phantom", url: "https://phantom.app", logoUrl: "p.circle.fill", type: .wallet),
        .init(name: "Ledger", url: "https://www.ledger.com", logoUrl: "l.circle.fill", type: .wallet),
        .init(name: "Trezor", url: "https://trezor.io", logoUrl: "t.circle.fill", type: .wallet),
        .init(name: "Exodus", url: "https://www.exodus.com", logoUrl: "e.circle.fill", type: .wallet)
    ]
    
    static var popular: [Connectable] {
        // Mix of popular items
        return [
            brokers[0], // IBKR
            exchanges[0], // Coinbase
            wallets[0], // MetaMask
            brokers[1], // Robinhood
            exchanges[1], // Binance
            wallets[1] // Trust
        ]
    }
    
    static var all: [Connectable] {
        return brokers + exchanges + wallets
    }
}
