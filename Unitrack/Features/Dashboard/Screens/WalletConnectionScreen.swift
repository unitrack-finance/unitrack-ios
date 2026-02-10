//
//  WalletConnectionScreen.swift
//  Unitrack
//
//  Created by Sylus Abel on 10/02/2026.
//

import SwiftUI

enum ConnectionMethod {
    case publicAddress
    case manual
}

struct WalletConnectionScreen: View {
    let wallet: Connectable
    let method: ConnectionMethod
    
    @State private var addressInput = ""
    
    var body: some View {
        VStack(spacing: 24) {
            // Header Logo
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    Image(systemName: wallet.logoUrl)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 64, height: 64)
                        .foregroundStyle(Color.orange) // Brand color placeholder
                        .padding(12)
                        .background(Color.cardBackgroundSecondary, in: Circle())
                    
                    Image(systemName: "arrow.right")
                        .foregroundStyle(Color.textSecondary)
                    
                    Text("U") // App Logo Placeholder
                        .font(.largeTitle)
                        .bold()
                        .frame(width: 64, height: 64)
                        .background(Color.cardBackgroundSecondary, in: Circle())
                }
                
                Text(method == .publicAddress ? "Public address" : "Connect")
                    .customFont(.title2)
                    .foregroundStyle(Color.textPrimary)
                
                Text("Your public address allows us to read your wallet activity and accurately sync your crypto transactions with our app.")
                    .customFont(.body)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .padding(.top, 32)
            
            // Input Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Address")
                    .customFont(.caption)
                    .foregroundStyle(Color.textSecondary)
                
                HStack {
                    TextField("0x...", text: $addressInput)
                        .customFont(.body)
                        .foregroundStyle(Color.textPrimary)
                    
                    Button {
                        // Scan QR Code Action
                    } label: {
                        Image(systemName: "qrcode.viewfinder")
                            .font(.title2)
                            .foregroundStyle(Color.textPrimary)
                    }
                }
                .padding(16)
                .background(Color.cardBackgroundSecondary, in: RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            // Connect Button
            Button {
                // Connect Action
            } label: {
                Text("Connect")
                    .customFont(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(addressInput.isEmpty ? Color.secondary.opacity(0.3) : Color.blue, in: RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(addressInput.isEmpty ? Color.textSecondary : .white)
            }
            .disabled(addressInput.isEmpty)
            .padding(16)
            .padding(.bottom, 16)
        }
        .background(Color.screenBackground)
        .navigationTitle(wallet.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        WalletConnectionScreen(wallet: Supported.wallets[0], method: .publicAddress)
            .preferredColorScheme(.dark)
    }
}
