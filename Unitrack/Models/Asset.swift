//
//  Asset.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import SwiftUI


struct Asset: Identifiable {
    let id = UUID()
    let ticker: String
    let name: String
    let price: String
    let imageUrl: String
}
