//
//  QuickStatsSection.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import SwiftUI

struct QuickStatsSection: View {
    let stats: [StatItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Quick Stats")
                    .customFont(.headline)
                  
                Spacer()
                NavigationArrowButton(action: {})
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(stats) { item in
                        StatCard(item: item)
                    }
                }
            }
        }
    }
}
