//
//  LiabilitiesScreen.swift
//  Unitrack
//
//  Created by Sylus Abel on 09/02/2026.
//

import SwiftUI

struct LiabilitiesScreen: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "creditcard")
                .font(.system(size: 80))
                .foregroundStyle(.orange)
            
            VStack(spacing: 12) {
                Text("Add Liabilities")
                    .customFont(.title2)
                    .foregroundStyle(Color.textPrimary)
                
                Text("This screen will allow you to track credit cards, loans, mortgages and other liabilities.")
                    .customFont(.body)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.screenBackground)
        .navigationTitle("Add Liabilities")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    LiabilitiesScreen()
        .preferredColorScheme(.dark)
}
