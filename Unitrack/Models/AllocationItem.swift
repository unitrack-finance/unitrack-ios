//
//  AllocationItem.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import SwiftUI

enum DataSource {
    case plaid
    case manual
}

struct AllocationItem: Identifiable {
    let id = UUID()
    let name: String
    let value: Int
    let color: Color
    let source: DataSource
}
