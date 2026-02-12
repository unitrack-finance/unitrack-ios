//
//  HoldingsSection.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import SwiftUI

struct HoldingsSection: View {
    let holdings: [HoldingItem]
    @State private var selectedHolding: HoldingItem?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Top Holdings")
                    .customFont(.headline)
                    
                Spacer()
                Button("View All") {}
                    .customFont(.caption)
                   
            }

            VStack(spacing: 10) {
                ForEach(holdings) { holding in
                    Button {
                        selectedHolding = holding
                    } label: {
                        HoldingRow(item: holding)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .sheet(item: $selectedHolding) { holding in
            EditManualAssetView(asset: holding) {
                // Refresh data if needed, DashboardViewModel handles this via onAppear or sync
            }
        }
    }
}
