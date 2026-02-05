//
//  AnalyticsView.swift
//  Unitrack
//
//  Created by Sylus Abel on 05/02/2026.
//

import SwiftUI

struct AnalyticsView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "chart.pie")
                    .font(.system(size: 48))
                    .foregroundStyle(.purple)
                Text("Analytics")
                    .font(.title3.weight(.semibold))
                Text("Premium insights will appear here.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Button("Unlock Premium") {}
                    .buttonStyle(.bordered)
            }
            .padding()
            .navigationTitle("Analytics")
        }
    }
}

#Preview {
    AnalyticsView()
}
