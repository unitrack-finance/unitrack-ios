//
//  AllocationSection.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import SwiftUI

struct AllocationSection: View {
    let allocation: [AllocationItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Portfolio Allocation")
                    .customFont(.headline)
                   
                Spacer()
                NavigationArrowButton(action: {})
            }

            HStack(spacing: 20) {
                AllocationRingView(items: allocation)
                    .frame(height: 300)
            }
        }
        .padding(20)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}
