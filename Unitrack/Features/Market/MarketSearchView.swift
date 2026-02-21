//
//  MarketSearchView.swift
//  Unitrack
//
//  Created by Sylus Abel on 12/02/2026.
//

import SwiftUI

struct MarketSearchView: View {
    @State private var searchText = ""
    @State private var results: [MarketSearchResult] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    ProgressView()
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else if results.isEmpty && !searchText.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        Text("No results found for \"\(searchText)\"")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                } else {
                    List(results) { asset in
                        NavigationLink(destination: MarketAssetDetailView(ticker: asset.ticker)) {
                            MarketResultRow(asset: asset)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Market Search")
            .searchable(text: $searchText, prompt: "Search stocks, crypto...")
            .onChange(of: searchText) { newValue, _ in
                if newValue.isEmpty {
                    results = []
                } else {
                    Task {
                        await performSearch(query: newValue)
                    }
                }
            }
        }
    }
    
    private func performSearch(query: String) async {
        guard !query.isEmpty else { return }
        
        // Debounce slightly
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        if query != searchText { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let assets = try await MarketService.shared.search(query: query)
            await MainActor.run {
                self.results = assets
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.userFriendlyMessage
                self.isLoading = false
            }
        }
    }
}

private struct MarketResultRow: View {
    let asset: MarketSearchResult
    
    var body: some View {
        HStack {
            if let logo = asset.logoUrl, let url = URL(string: logo) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Circle().fill(Color.gray.opacity(0.3))
                }
                .frame(width: 32, height: 32)
                .clipShape(Circle())
            } else {
                Circle()
                    .fill(.purple.opacity(0.1))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Text(String(asset.ticker.prefix(1)))
                            .foregroundStyle(.purple)
                    )
            }
            
            VStack(alignment: .leading) {
                Text(asset.ticker)
                    .font(.headline)
                Text(asset.name)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(asset.type)
                .font(.caption2)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.gray.opacity(0.1), in: Capsule())
        }
    }
}

#Preview {
    MarketSearchView()
}
