//
//  AssetView.swift
//  Unitrack
//
//  Created by Sylus Abel on 10/02/2026.
//

import SwiftUI

struct AssetView: View {
    @State private var searchText = ""
    @State private var selectedAsset: AssetSearchResult?
    
    // Dummy Data
    let assets = [
        AssetSearchResult(ticker: "AAPL", name: "Apple Inc.", type: "Stock", logoUrl: "apple.logo"),
        AssetSearchResult(ticker: "MSFT", name: "Microsoft Corp", type: "Stock", logoUrl: "windows_logo"), // System image placeholder
        AssetSearchResult(ticker: "BTC", name: "Bitcoin", type: "Crypto", logoUrl: "bitcoinsign.circle.fill"),
        AssetSearchResult(ticker: "ETH", name: "Ethereum", type: "Crypto", logoUrl: "diamond.fill")
    ]
    
    var filteredAssets: [AssetSearchResult] {
        if searchText.isEmpty {
            return assets
        } else {
            return assets.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.ticker.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Color.textSecondary)
                        TextField("Search assets (e.g. AAPL, BTC)", text: $searchText)
                            .customFont(.body)
                    }
                    .padding(12)
                    .background(Color.cardBackgroundSecondary, in: RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 16)
                    
                    // List
                    LazyVStack(spacing: 12) {
                        ForEach(filteredAssets) { asset in
                            Button {
                                selectedAsset = asset
                            } label: {
                                AssetRow(asset: asset)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.top, 16)
            }
            .background(Color.screenBackground.ignoresSafeArea())
            .navigationTitle("Assets")
            .navigationDestination(item: $selectedAsset) { asset in
                AssetDetailsView(asset: asset)
            }
        }
    }
}

struct AssetRow: View {
    let asset: AssetSearchResult
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon Placeholder
            Circle()
                .fill(Color.cardBackgroundSecondary)
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: asset.logoUrl ?? "building.columns.fill")
                        .foregroundStyle(Color.textPrimary)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(asset.ticker)
                    .customFont(.headline)
                    .foregroundStyle(Color.textPrimary)
                Text(asset.name)
                    .customFont(.caption)
                    .foregroundStyle(Color.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.textSecondary)
                .font(.caption)
        }
        .padding(16)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    AssetView()
}
