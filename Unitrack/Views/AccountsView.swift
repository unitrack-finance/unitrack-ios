//
//  AccountsView.swift
//  Unitrack
//
//  Created by Sylus Abel on 05/02/2026.
//

import SwiftUI

struct MarketOverviewView: View {
    @State var searchTerm = ""
    @State private var searchResults: [MarketSearchResult] = []
    @State private var isSearching = false
    @State private var searchError: String?
    
    // Placeholder stats for the UI
    private let stats: [StatItem] = [
        .init(id: UUID().uuidString, title: "Best Performer", subtitle: "AAPL", value: "+4.8%", icon: "arrow.up.right.circle.fill", isPositive: true),
        .init(id: UUID().uuidString, title: "Worst Performer", subtitle: "ETH", value: "-2.1%", icon: "arrow.down.right.circle.fill", isPositive: false)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    HStack {
                        Text("Search")
                            .customFont(.title)
                        Spacer()
                    }
                    
                    TextField("", text: $searchTerm)
                        .customTextField(image: Image(systemName: "magnifyingglass"))
                        .foregroundStyle(Color.gray)
                        .textInputAutocapitalization(.never)
                        .onSubmit {
                            performSearch()
                        }
                    
                    if isSearching {
                        ProgressView()
                            .padding()
                    } else if let error = searchError {
                        Text(error)
                            .customFont(.caption)
                            .foregroundStyle(.red)
                    } else if !searchResults.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Market Results")
                                .customFont(.subheadline)
                                .opacity(0.5)
                            
                            ForEach(searchResults) { result in
                                NavigationLink(destination: MarketAssetDetailView(ticker: result.ticker)) {
                                    MarketResultRow(result: result)
                                }
                            }
                        }
                    } else {
                        SuggestedStatsSection(stats: stats)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 50)
            }
            .scrollIndicators(.hidden)
            .alert("Search Error", isPresented: Binding(
                get: { searchError != nil },
                set: { if !$0 { searchError = nil } }
            )) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(searchError ?? "An unknown error occurred")
            }
        }
    }
    
    private func performSearch() {
        guard !searchTerm.isEmpty else { return }
        isSearching = true
        searchError = nil
        
        Task {
            do {
                let results = try await MarketService.shared.search(query: searchTerm)
                await MainActor.run {
                    self.searchResults = results
                    self.isSearching = false
                }
            } catch {
                await MainActor.run {
                    self.searchError = error.userFriendlyMessage
                    self.isSearching = false
                }
            }
        }
    }
}

private struct MarketResultRow: View {
    let result: MarketSearchResult
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: result.logoUrl ?? "")) { image in
                image.resizable()
            } placeholder: {
                Circle().fill(Color.cardBackgroundSecondary)
            }
            .frame(width: 44, height: 44)
            .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(result.ticker)
                    .customFont(.headline)
                Text(result.name)
                    .customFont(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(result.type)
                .customFont(.caption2)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.cardBackgroundSecondary, in: Capsule())
        }
        .padding()
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 16))
    }
}

private struct SuggestedStatsSection: View {
    let stats: [StatItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Suggested")
                    .customFont(.subheadline)
                    .opacity(0.5)
                Spacer()
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(stats) { item in
                        StatCard(item: item)
                    }
                }
            }
        }
    }
}

private struct MarketAssetCard: View {
    let item: Asset
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AsyncImage(url: URL(string: item.imageUrl)) { image in
                    image
                        .resizable()
                        .background(Circle())
                        .padding(12)
                        .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 40))
                            .overlay(
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                } placeholder: {
                    ProgressView()
                }
                    .frame(width: 54, height: 54)
                VStack(alignment: .leading) {
                    Text(item.ticker)
                        .customFont(.subheadline)
                    Text(item.name)
                        .customFont(.footnote)
                        .opacity(0.5)
                }
                    
            }
        }
    }
}

private struct MarketMostSearchedAssets: View {
    let assets: [Asset]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Most searched assets")
                    .customFont(.subheadline)
                    .opacity(0.5)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 12) {
                ForEach(assets) { item in
                    MarketAssetCard(item: item)
                }
            }
            
        }
    }
}


#Preview {
    MarketOverviewView()
}
