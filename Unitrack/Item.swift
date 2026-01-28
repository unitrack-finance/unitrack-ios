//
//  Item.swift
//  Unitrack
//
//  Created by Sylus Abel on 28/01/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
