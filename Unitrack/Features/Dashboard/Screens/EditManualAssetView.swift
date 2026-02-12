//
//  EditManualAssetView.swift
//  Unitrack
//
//  Created by Sylus Abel on 12/02/2026.
//

import SwiftUI

struct EditManualAssetView: View {
    @Environment(\.dismiss) private var dismiss
    
    let asset: HoldingItem
    
    @State private var value: String = ""
    @State private var quantity: String = ""
    @State private var notes: String = ""
    @State private var date: Date = Date()
    @State private var isSaving = false
    @State private var errorMessage: String?
    @State private var showDeleteAlert = false
    
    var onUpdate: () -> Void
    
    init(asset: HoldingItem, onUpdate: @escaping () -> Void) {
        self.asset = asset
        self.onUpdate = onUpdate
        _value = State(initialValue: String(asset.value))
        _quantity = State(initialValue: String(asset.quantity ?? 0))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(asset.name)
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Type")
                        Spacer()
                        Text(asset.source ?? "Manual")
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("Asset Details")
                }
                
                Section {
                    TextField("Value", text: $value)
                        .keyboardType(.decimalPad)
                    
                     TextField("Quantity", text: $quantity)
                        .keyboardType(.decimalPad)
                    
                    DatePicker("Transaction Date", selection: $date, displayedComponents: .date)
                    
                    TextField("Notes", text: $notes)
                } header: {
                    Text("Update Information")
                }
                
                if let errorMessage = errorMessage {
                     Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
                
                Section {
                    Button {
                        saveChanges()
                    } label: {
                        if isSaving {
                            ProgressView()
                        } else {
                            Text("Save Changes")
                        }
                    }
                    .disabled(isSaving)
                }
                
                Section {
                     Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Text("Delete Asset")
                    }
                }
            }
            .navigationTitle("Edit Asset")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Delete Asset", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteAsset()
                }
            } message: {
                Text("Are you sure you want to delete this asset? This action cannot be undone.")
            }
        }
    }
    
    private func saveChanges() {
        guard let valueDouble = Double(value), let _ = Double(quantity) else {
            errorMessage = "Invalid value or quantity"
            return
        }
        
        isSaving = true
        errorMessage = nil
        
        Task {
            do {
                let deletionId = asset.portfolioId ?? asset.id
                 try await ManualAssetService.shared.updateAsset(
                    id: deletionId,
                    value: valueDouble,
                    date: date
                 )
                
                await MainActor.run {
                    onUpdate()
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.userFriendlyMessage
                    isSaving = false
                }
            }
        }
    }
    
    private func deleteAsset() {
        print("🔍 Full Asset Data before deletion: \(asset)")
        let deletionId = asset.portfolioId ?? asset.id
        print("🗑️ Using ID for deletion: \(deletionId)")
        
        isSaving = true
        errorMessage = nil
        
        Task {
            do {
                 try await ManualAssetService.shared.deleteAsset(id: deletionId)
                 await MainActor.run {
                    onUpdate()
                    dismiss()
                }
            } catch {
                await MainActor.run {
                     errorMessage = error.userFriendlyMessage
                     isSaving = false
                }
            }
        }
    }
}

#Preview {
    EditManualAssetView(asset: HoldingItem(id: "1", portfolioId: nil, name: "Bitcoin", source: "manual", value: 50000, price: 50000, currentPrice: 50000, costBasis: 45000, quantity: 1, ticker: "BTC", change24h: 0, isPositive: true, icon: nil), onUpdate: {})
}
