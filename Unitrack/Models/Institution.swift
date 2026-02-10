//
//  Institution.swift
//  Unitrack
//

import Foundation

struct Institution: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let logoName: String // Using system symbols or assets
    let category: InstitutionCategory
    
    init(name: String, logoName: String, category: InstitutionCategory) {
        self.name = name
        self.logoName = logoName
        self.category = category
    }
    
    init(from connectable: Connectable) {
        self.name = connectable.name
        self.logoName = connectable.logoUrl
        self.category = InstitutionCategory(rawValue: connectable.type.rawValue) ?? .popular
    }
}

enum InstitutionCategory: String, CaseIterable {
    case popular = "Popular"
    case brokers = "Brokers"
    case exchanges = "Exchanges"
    case wallets = "Wallets"
    case alternatives = "Alternatives"
}
