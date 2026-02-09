//
//  CashScreen.swift
//  Unitrack
//
//  Created by Sylus Abel on 09/02/2026.
//

import SwiftUI

struct CashScreen: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "banknote")
                .font(.system(size: 80))
                .foregroundStyle(.green)
            
            VStack(spacing: 12) {
                Text("Add Cash Accounts")
                    .customFont(.title2)
                    .foregroundStyle(Color.textPrimary)
                
                Text("This screen will allow you to add current accounts, savings accounts and other cash holdings.")
                    .customFont(.body)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.screenBackground)
        .navigationTitle("Add Cash Accounts")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CashScreen()
        .preferredColorScheme(.dark)
}
