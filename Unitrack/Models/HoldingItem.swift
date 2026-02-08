//
//  HoldingItem.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import Foundation

struct HoldingItem: Identifiable {
    let id = UUID()
    let name: String
    let source: String
    let value: String
    let change: String
    let isPositive: Bool
    let icon: String
}
