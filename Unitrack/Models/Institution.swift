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
}

enum InstitutionCategory: String, CaseIterable {
    case popular = "Popular"
    case brokers = "Brokers"
    case exchanges = "Exchanges"
    case wallets = "Wallets"
    case alternatives = "Alternatives"
}
