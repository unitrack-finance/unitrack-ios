//
//  ManualTransactionScreen.swift
//  Unitrack
//
//  Created by Sylus Abel on 10/02/2026.
//

import SwiftUI

enum ManualAssetType: String, CaseIterable, Identifiable {
    case crypto = "Crypto"
    case bond = "Bond"
    case cash = "Cash"
    case realEstate = "Real Estate"
    case nft = "NFT"
    case commodities = "Commodities"
    case p2p = "P2P Loans"
    case art = "Art"
    
    var id: String { rawValue }
}

struct ManualTransactionScreen: View {
    @State private var selectedType: ManualAssetType = .realEstate
    
    // Form States
    @State private var transactionType = "Buy"
    @State private var description = ""
    @State private var date = Date()
    @State private var price = ""
    @State private var selectedCurrency = "KES"
    
    let transactionTypes = ["Buy", "Sell", "Deposit", "Withdrawal"]
    let currencies = ["KES", "USD", "EUR", "GBP"]
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Custom Tab Bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(ManualAssetType.allCases) { type in
                            Button {
                                withAnimation {
                                    selectedType = type
                                }
                            } label: {
                                VStack(spacing: 8) {
                                    Text(type.rawValue)
                                        .customFont(selectedType == type ? .headline : .body)
                                        .foregroundStyle(selectedType == type ? Color.textPrimary : Color.textSecondary)
                                    
                                    Rectangle()
                                        .fill(selectedType == type ? Color.textPrimary : Color.clear)
                                        .frame(height: 2)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 16)
                
                // Form Fields
                VStack(spacing: 20) {
                    // Transaction Type
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Transaction Type")
                            .customFont(.caption)
                            .foregroundStyle(Color.textSecondary)
                        
                        Menu {
                            ForEach(transactionTypes, id: \.self) { type in
                                Button(type) { transactionType = type }
                            }
                        } label: {
                            HStack {
                                Text(transactionType)
                                    .customFont(.body)
                                    .foregroundStyle(Color.textPrimary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                                    .foregroundStyle(Color.textTertiary)
                            }
                            .padding(16)
                            .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .customFont(.caption)
                            .foregroundStyle(Color.textSecondary)
                        
                        TextField("e.g. Condo Baker Street", text: $description)
                            .customFont(.body)
                            .padding(16)
                            .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 8))
                    }
                    
                    // Transaction Date
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Transaction Date")
                            .customFont(.caption)
                            .foregroundStyle(Color.textSecondary)
                        
                        HStack {
                            Text(date.formatted(date: .long, time: .omitted))
                                .customFont(.body)
                                .foregroundStyle(Color.textPrimary)
                            Spacer()
                            Image(systemName: "calendar")
                                .foregroundStyle(Color.textPrimary)
                                .overlay {
                                    DatePicker("", selection: $date, displayedComponents: .date)
                                        .blendMode(.destinationOver)
                                        .labelsHidden()
                                        .opacity(0.011) // Invisible but clickable
                                }
                        }
                        .padding(16)
                        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 8))
                    }
                    
                    // Purchase Price
                    VStack(alignment: .leading, spacing: 8) {
                        Text(selectedType == .cash ? "Amount" : "Purchase Price")
                            .customFont(.caption)
                            .foregroundStyle(Color.textSecondary)
                        
                        HStack {
                            TextField("e.g. KES 150.00", text: $price)
                                .keyboardType(.decimalPad)
                                .customFont(.body)
                            
                            Menu {
                                ForEach(currencies, id: \.self) { currency in
                                    Button(currency) { selectedCurrency = currency }
                                }
                            } label: {
                                HStack(spacing: 4) {
                                    Text(selectedCurrency)
                                        .customFont(.subheadline)
                                        .bold()
                                    Image(systemName: "chevron.down")
                                        .font(.caption2)
                                }
                                .foregroundStyle(Color.textPrimary)
                            }
                        }
                        .padding(16)
                        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(.horizontal, 20)
                
                // Total Amount
                HStack {
                    Text("Total Amount")
                        .customFont(.headline)
                        .foregroundStyle(Color.textPrimary)
                    Spacer()
                    Text("\(selectedCurrency) \(price.isEmpty ? "0.00" : price)")
                        .customFont(.title3)
                        .foregroundStyle(Color.textPrimary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                Spacer(minLength: 20)
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button {
                        // Add Action
                        dismiss()
                    } label: {
                        Text("Add Transaction")
                            .customFont(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.textPrimary, in: RoundedRectangle(cornerRadius: 8))
                            .foregroundStyle(Color.screenBackground)
                    }
                    
                    Button {
                        // Save & add another action
                        description = ""
                        price = ""
                    } label: {
                        Text("Save and Add Another")
                            .customFont(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.clear)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.textSecondary.opacity(0.3), lineWidth: 1))
                            .foregroundStyle(Color.textPrimary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .background(Color.screenBackground)
        .navigationTitle("Add Transaction")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ManualTransactionScreen()
            .preferredColorScheme(.light)
    }
}
