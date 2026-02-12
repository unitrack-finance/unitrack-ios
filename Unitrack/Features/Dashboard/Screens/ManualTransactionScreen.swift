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
    
    var apiValue: String {
        switch self {
        case .crypto: return "CRYPTO"
        case .bond: return "BOND"
        case .cash: return "CASH"
        case .realEstate: return "REAL_ESTATE"
        case .nft: return "NFT"
        case .commodities: return "COMMODITY"
        case .p2p: return "P2P_LOAN"
        case .art: return "COLLECTIBLE"
        }
    }
}

struct ManualTransactionScreen: View {
    @State private var selectedType: ManualAssetType = .realEstate
    
    // Form States
    @State private var transactionType = "Buy"
    @State private var description = ""
    @State private var date = Date()
    @State private var price = ""
    @State private var currentValue = ""
    @State private var selectedCurrency = "KES"
    
    @State private var propertyTaxDate = Date()
    @State private var isinNumber = ""
    @State private var nominalQuantity = ""
    @State private var percentage = ""
    @State private var tradingCosts = ""
    @State private var taxes = ""
    @State private var cryptoSymbol = ""
    @State private var cryptoQuantity = ""
    @State private var showCryptoSearch = false
    
    @State private var isSaving = false
    @State private var saveError: String?
    @State private var showAlert = false
    @State private var isSuccess = false
    
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
                                    resetForm(for: type)
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
                    if showTransactionType {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Transaction Type")
                                .customFont(.caption)
                                .foregroundStyle(Color.textSecondary)
                            
                            Menu {
                                ForEach(availableTransactionTypes, id: \.self) { type in
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
                    }
                    
                    // Specific fields based on type
                    Group {
                        if selectedType == .crypto {
                            // Crypto Search Button
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Symbol")
                                    .customFont(.caption)
                                    .foregroundStyle(Color.textSecondary)
                                
                                Button {
                                    showCryptoSearch = true
                                } label: {
                                    HStack {
                                        Text(cryptoSymbol.isEmpty ? "Search Crypto (e.g. BTC)" : cryptoSymbol)
                                            .customFont(.body)
                                            .foregroundStyle(cryptoSymbol.isEmpty ? Color.textTertiary : Color.textPrimary)
                                        Spacer()
                                        Image(systemName: "magnifyingglass")
                                            .foregroundStyle(Color.textTertiary)
                                    }
                                    .padding(16)
                                    .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 8))
                                }
                            }
                            
                            fieldView(title: "Quantity", placeholder: "e.g. 0.5", text: $cryptoQuantity, keyboardType: .decimalPad)
                        }
                        
                        if selectedType == .bond {
                            fieldView(title: "Bond ISIN Number", placeholder: "e.g. US0378331005", text: $isinNumber)
                            fieldView(title: "Nominal Quantity", placeholder: "e.g. 1000", text: $nominalQuantity, keyboardType: .decimalPad)
                            fieldView(title: "Percentage (%)", placeholder: "e.g. 4.5", text: $percentage, keyboardType: .decimalPad)
                        }
                        
                        if selectedType != .bond && selectedType != .crypto {
                            fieldView(title: "Description", placeholder: "Enter description", text: $description)
                        }
                    }
                    
                    // Common Date Field
                    datePickerView(title: "Transaction Date", date: $date)
                    
                    // Purchase Price (for most)
                    if selectedType != .cash {
                        priceFieldView(title: "Purchase Price", text: $price)
                    } else {
                        priceFieldView(title: "Amount", text: $price)
                    }
                    
                    // Current Value (for some)
                    if [.realEstate, .nft, .commodities, .art].contains(selectedType) {
                        priceFieldView(title: "Current Value", text: $currentValue)
                    }
                    
                    // Extra fields for Real Estate
                    if selectedType == .realEstate {
                        datePickerView(title: "Next Property Tax Date", date: $propertyTaxDate)
                    }
                    
                    // Trading costs and taxes for Bonds and Crypto
                    if [.bond, .crypto].contains(selectedType) {
                        fieldView(title: "Trading Costs", placeholder: "e.g. 10.00", text: $tradingCosts, keyboardType: .decimalPad)
                        fieldView(title: "Taxes", placeholder: "e.g. 5.00", text: $taxes, keyboardType: .decimalPad)
                    }
                }
                .padding(.horizontal, 20)
                
                // Total Amount Summary
                if !price.isEmpty || !tradingCosts.isEmpty || !taxes.isEmpty {
                    VStack(spacing: 12) {
                        Divider()
                            .background(Color.textTertiary.opacity(0.2))
                        
                        HStack {
                            Text("Total Outflow")
                                .customFont(.headline)
                                .foregroundStyle(Color.textPrimary)
                            Spacer()
                            Text("\(selectedCurrency) \(calculateTotal())")
                                .customFont(.title3)
                                .foregroundStyle(Color.textPrimary)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                }
                
                Spacer(minLength: 20)
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button {
                        saveTransaction()
                    } label: {
                        if isSaving {
                            ProgressView()
                                .tint(.screenBackground)
                        } else {
                            Text("Add Transaction")
                                .customFont(.headline)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.textPrimary, in: RoundedRectangle(cornerRadius: 8))
                    .foregroundStyle(Color.screenBackground)
                    .disabled(isSaving)
                    
                    Button {
                        resetForm(for: selectedType)
                    } label: {
                        Text("Clear All")
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
        .navigationTitle("Add \(selectedType.rawValue)")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showCryptoSearch) {
            CryptoSearchSheet(selectedSymbol: $cryptoSymbol)
        }
        .alert(isSuccess ? "Success" : "Error", isPresented: $showAlert) {
            Button("OK") {
                if isSuccess { dismiss() }
            }
        } message: {
            Text(isSuccess ? "Asset added successfully." : (saveError ?? "An unknown error occurred."))
        }
    }
    
    // Helper Views
    private func fieldView(title: String, placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .customFont(.caption)
                .foregroundStyle(Color.textSecondary)
            
            TextField(placeholder, text: text)
                .keyboardType(keyboardType)
                .customFont(.body)
                .padding(16)
                .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 8))
        }
    }
    
    private func priceFieldView(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .customFont(.caption)
                .foregroundStyle(Color.textSecondary)
            
            HStack {
                TextField("0.00", text: text)
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
    
    private func datePickerView(title: String, date: Binding<Date>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .customFont(.caption)
                .foregroundStyle(Color.textSecondary)
            
            HStack {
                Text(date.wrappedValue.formatted(date: .long, time: .omitted))
                    .customFont(.body)
                    .foregroundStyle(Color.textPrimary)
                Spacer()
                Image(systemName: "calendar")
                    .foregroundStyle(Color.textPrimary)
                    .overlay {
                        DatePicker("", selection: date, displayedComponents: .date)
                            .blendMode(.destinationOver)
                            .labelsHidden()
                            .opacity(0.011)
                    }
            }
            .padding(16)
            .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 8))
        }
    }
    
    // Logics
    private var showTransactionType: Bool {
        // Based on user rules: RE, Bonds, Commodities are "Buy only", Cash is "Deposit/Rewards"
        // But we want to show it if there are choices.
        availableTransactionTypes.count > 1
    }
    
    private var availableTransactionTypes: [String] {
        switch selectedType {
        case .realEstate, .bond, .commodities, .art:
            return ["Buy"]
        case .cash:
            return ["Deposit", "Rewards"]
        case .nft, .crypto:
            return ["Buy", "Receive", "Reward"]
        default:
            return ["Buy", "Sell"]
        }
    }
    
    private func resetForm(for type: ManualAssetType) {
        transactionType = availableTransactionTypes.first ?? "Buy"
        description = ""
        price = ""
        currentValue = ""
        isinNumber = ""
        nominalQuantity = ""
        percentage = ""
        tradingCosts = ""
        taxes = ""
        cryptoSymbol = ""
        cryptoQuantity = ""
    }
    
    private func calculateTotal() -> String {
        let p = Double(price) ?? 0
        let tc = Double(tradingCosts) ?? 0
        let tx = Double(taxes) ?? 0
        return String(format: "%.2f", p + tc + tx)
    }
    
    private func saveTransaction() {
        isSaving = true
        saveError = nil
        
        Task {
            do {
                let val = Double(currentValue) ?? Double(price) ?? 0
                _ = Double(cryptoQuantity) ?? Double(nominalQuantity) ?? 1.0
                let ticker: String? = selectedType == .crypto ? (cryptoSymbol.isEmpty ? nil : cryptoSymbol) : nil

                // TODO: Replace this placeholder with the actual selected portfolio id from your app state.
                let _: String = "default"

                let payload = CreateManualAssetPayload(
                    ticker: ticker ?? "",
                    name: description.isEmpty ? "\(selectedType.rawValue) Asset" : description,
                    type: selectedType.apiValue,
                    value: val,
                    currency: selectedCurrency,
                    date: "",
                )
                
                _ = try await ManualAssetService.shared.createAsset(ticker: payload.ticker, name: payload.name, type: payload.type, value: payload.value, currency: payload.currency, date: date)
                
                await MainActor.run {
                    isSaving = false
                    isSuccess = true
                    showAlert = true
                }
            } catch {
                await MainActor.run {
                    isSaving = false
                    isSuccess = false
                    saveError = error.userFriendlyMessage
                    showAlert = true
                }
            }
        }
    }
}

struct CryptoSearchSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedSymbol: String
    @State private var searchText = ""
    
    let mockCoins = ["BTC", "ETH", "SOL", "ADA", "DOT", "AVAX", "LINK", "MATIC"]
    
    var filteredCoins: [String] {
        if searchText.isEmpty { return mockCoins }
        return mockCoins.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredCoins, id: \.self) { coin in
                Button {
                    selectedSymbol = coin
                    dismiss()
                } label: {
                    HStack {
                        Text(coin)
                            .customFont(.body)
                        Spacer()
                    }
                }
                .foregroundStyle(Color.textPrimary)
            }
            .navigationTitle("Search Crypto")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search symbol...")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ManualTransactionScreen()
            .preferredColorScheme(.light)
    }
}

