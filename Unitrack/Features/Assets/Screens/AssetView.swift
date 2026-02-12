//
//  AssetView.swift
//  Unitrack
//
//  Created by Sylus Abel on 10/02/2026.
//

import SwiftUI

struct AssetView: View {
    @State private var searchText = ""
    @State private var selectedAsset: MarketSearchResult?
    
    // Dummy Data
    let assets = [
        MarketSearchResult(ticker: "AAPL", name: "Apple Inc.", type: "Stock", logoUrl: nil),
        MarketSearchResult(ticker: "MSFT", name: "Microsoft Corp", type: "Stock", logoUrl: nil),
        MarketSearchResult(ticker: "BTC", name: "Bitcoin", type: "Crypto", logoUrl: nil),
        MarketSearchResult(ticker: "ETH", name: "Ethereum", type: "Crypto", logoUrl: nil)
    ]
    
    var filteredAssets: [MarketSearchResult] {
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
                MarketAssetDetailView(ticker: asset.ticker)
            }
        }
    }
}

struct AssetRow: View {
    let asset: MarketSearchResult
    
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
