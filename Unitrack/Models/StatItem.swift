//
//  StatItem.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import Foundation

struct StatItem: Identifiable, Codable {
    let id: String
    let title: String
    let subtitle: String
    let value: String
    let icon: String
    let isPositive: Bool
}
