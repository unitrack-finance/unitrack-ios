//
//  InvestmentsScreen.swift
//  Unitrack
//

import SwiftUI

struct InvestmentsScreen: View {
    @State private var searchTerm = ""
    @State private var selectedCategory: InstitutionCategory = .popular
    
    var filteredItems: [Connectable] {
        let source: [Connectable]
        switch selectedCategory {
        case .popular: source = Supported.popular
        case .brokers: source = Supported.brokers
        case .exchanges: source = Supported.exchanges
        case .wallets: source = Supported.wallets
        case .alternatives: source = [] // Alternatives are manual only for now
        }
        
        if searchTerm.isEmpty { return source }
        
        return source.filter { item in
            item.name.localizedCaseInsensitiveContains(searchTerm)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Info Banner
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.textSecondary)
                    
                    Text("This will add new, selectable accounts to your net worth — including portfolios, cash, and liabilities. To update an existing account, open it and select \"Add transaction\".")
                        .customFont(.caption)
                        .foregroundStyle(Color.textSecondary)
                        .lineSpacing(4)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                // Search Bar
                TextField("Search for a bank, broker, wallet or e...", text: $searchTerm)
                    .customTextField(image: Image(systemName: "magnifyingglass"))
                    .padding(.horizontal, 20)
                
                // Category Tabs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 24) {
                        ForEach(InstitutionCategory.allCases, id: \.self) { category in
                            Button(action: { selectedCategory = category }) {
                                VStack(spacing: 8) {
                                    Text(category.rawValue)
                                        .customFont(selectedCategory == category ? .headline : .body)
                                        .foregroundStyle(selectedCategory == category ? Color.textPrimary : Color.textTertiary)
                                    
                                    // Selection Indicator
                                    Rectangle()
                                        .fill(selectedCategory == category ? Color.textPrimary : Color.clear)
                                        .frame(height: 2)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                // Institution Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(filteredItems) { item in
                        if item.type == .wallet {
                            NavigationLink(destination: WalletImportOptionsScreen(wallet: item)) {
                                InstitutionGridTile(institution: Institution(from: item))
                            }
                        } else {
                            NavigationLink(destination: ImportOptionsScreen(institution: Institution(from: item))) {
                                InstitutionGridTile(institution: Institution(from: item))
                            }
                        }
                    }
                    
                    // Manual Portfolio Option
                    NavigationLink(destination: ManualTransactionScreen()) {
                        VStack(spacing: 12) {
                            Image(systemName: "pencil")
                                .font(.system(size: 24))
                                .foregroundStyle(Color.textPrimary)
                            
                            Text("Manual Portfolio")
                                .customFont(.caption)
                                .foregroundStyle(Color.textPrimary)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 160)
                        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer(minLength: 50)
            }
            .padding(.top, 16)
        }
        .background(Color.screenBackground)
        .navigationTitle("Add new portfolio")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InstitutionGridTile: View {
    let institution: Institution
    
    var body: some View {
        VStack(spacing: 16) {
            // Logo placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.cardBackgroundSecondary)
                    .frame(width: 64, height: 64)
                
                Image(systemName: institution.logoName)
                    .font(.system(size: 28))
                    .foregroundStyle(Color.textPrimary)
            }
            
            Text(institution.name)
                .customFont(.caption)
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    NavigationStack {
        InvestmentsScreen()
            .preferredColorScheme(.dark)
    }
}
