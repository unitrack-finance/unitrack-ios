//
//  AddWalletSheet.swift
//  Unitrack
//
//  Created by Sylus Abel on 12/02/2026.
//

import SwiftUI

struct AddWalletSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var address: String = ""
    @State private var label: String = ""
    @State private var isConnecting = false
    @State private var errorMessage: String?
    
    var onWalletConnected: () -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Wallet Address (0x...)", text: $address)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    
                    TextField("Label (Optional)", text: $label)
                } header: {
                    Text("Wallet Details")
                } footer: {
                    Text("Connect your EVM wallet to track your assets.")
                }
                
                if let errorMessage = errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
                
                Section {
                    Button {
                        connectWallet()
                    } label: {
                        if isConnecting {
                            ProgressView()
                        } else {
                            Text("Connect Wallet")
                        }
                    }
                    .disabled(address.isEmpty || isConnecting)
                }
            }
            .navigationTitle("Connect Wallet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func connectWallet() {
        guard !address.isEmpty else { return }
        
        isConnecting = true
        errorMessage = nil
        
        Task {
            do {
                _ = try await ConnectionService.shared.connectWallet(address: address, label: label.isEmpty ? nil : label)
                await MainActor.run {
                    onWalletConnected()
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isConnecting = false
                }
            }
        }
    }
}

#Preview {
    AddWalletSheet(onWalletConnected: {})
}
