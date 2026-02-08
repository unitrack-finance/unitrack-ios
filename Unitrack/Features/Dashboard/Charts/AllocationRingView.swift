//
//  AllocationRingView.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import SwiftUI
import Charts

struct AllocationRingView: View {
    let items: [AllocationItem]
    
    var largestPositionItem: AllocationItem? {
        items.max(by: { $0.value < $1.value })
    }

    var body: some View {
        Chart(items, id: \.name) { element in
            SectorMark (
                angle: .value("Allocations", element.value),
                innerRadius: .ratio(0.618),
                angularInset: 1.5
            )
            .cornerRadius(5)
            .foregroundStyle(by: .value("Name", element.name))
            }
        .chartBackground { chartProxy in
            GeometryReader { geometry in
                let frame = geometry[chartProxy.plotAreaFrame]
                VStack {
                    Text("Largest Position")
                        .customFont(.caption2)
                        .foregroundStyle(Color.textSecondary)
                    if let largest = largestPositionItem {
                        Text(largest.name)
                            .customFont(.headline)
                    }
                }
                .position(x: frame.midX, y:frame.midY)
            }
        }        }
}
