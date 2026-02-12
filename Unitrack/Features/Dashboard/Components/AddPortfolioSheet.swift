//
//  AddPortfolioSheet.swift
//  Unitrack
//
//  Created by Sylus Abel on 09/02/2026.
//

import SwiftUI

struct AddPortfolioSheet: View {
    @Environment(\.dismiss) private var dismiss
    var onSelect: (PortfolioType) -> Void
    @State private var showExpectedWallet = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("Add Portfolio")
                    .customFont(.title2)
                    .foregroundStyle(Color.textPrimary)
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color.textTertiary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            
            // Portfolio type options
            VStack(spacing: 16) {
                ForEach(PortfolioType.allCases, id: \.self) { type in
                    PortfolioTypeCard(portfolioType: type) {
                        onSelect(type)
                    }
                }
            }
            .padding(.horizontal, 20)
            
            // Button(action: { showExpectedWallet = true }) {
            //     HStack {
            //         Image(systemName: "link")
            //             .font(.headline)
            //         Text("Connect Web3 Wallet")
            //             .font(.headline)
            //     }
            //     .frame(maxWidth: .infinity)
            //     .padding()
            //     .background(Color.purple.opacity(0.1))
            //     .foregroundColor(.pink)
            //     .cornerRadius(12)
            // }
            // .padding(.horizontal, 20)
            
            Spacer()
        }
        .background(Color.screenBackground)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .sheet(isPresented: $showExpectedWallet) {
            AddWalletSheet {
                dismiss()
            }
        }
    }
}

#Preview {
    AddPortfolioSheet(onSelect: { _ in })
        .preferredColorScheme(.dark)
}
