//
//  AccountsView.swift
//  Unitrack
//
//  Created by Sylus Abel on 05/02/2026.
//

import SwiftUI

struct AssetsView: View {
    @State var searchTerm = ""
    private let stats: [StatItem] = [
        .init(title: "Best Performer", subtitle: "AAPL", value: "+4.8%", icon: "arrow.up.right.circle.fill", isPositive: true),
        .init(title: "Worst Performer", subtitle: "ETH", value: "-2.1%", icon: "arrow.down.right.circle.fill", isPositive: false),
        .init(title: "Top Holding", subtitle: "VTI", value: "$18,420", icon: "star.circle.fill", isPositive: true),
        .init(title: "Top Mover", subtitle: "BTC", value: "+17.6%", icon: "chart.bar.fill", isPositive: true)
    ]
    private let assets: [Asset] = [
        .init(ticker: "MSFT", name: "Microsoft", price: "$292.66", imageUrl: "https://companieslogo.com/img/orig/MSFT-a203b22d.png?t=1722952497"),
        .init(ticker: "ETH", name: "Ethereum", price: "$2077.25", imageUrl: "https://cdn.pixabay.com/photo/2021/05/24/09/15/ethereum-logo-6278329_1280.png"),
        .init(ticker: "AAPL", name: "Apple", price: "$456.87", imageUrl: "https://g.foolcdn.com/art/companylogos/square/aapl.png"),
        .init(ticker: "DOW", name: "Dow Jones", price: "$26,598.12", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMU2Zf9sCjK9NFBEIy3OAiD7AqEy1_vXv4pg&s")
    ]
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    HStack{
                        Text("Search")
                            .customFont(.title)
                        Spacer()
                    }
                    TextField("", text: $searchTerm)
                        .customTextField(image: Image(systemName: "magnifyingglass"))
                        .foregroundStyle(Color.gray)
                        .textInputAutocapitalization(.never)
                    SuggestedStatsSection(stats: stats)
                    MostSearchedAssets(assets: assets)
                        
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 50)
            }
            .scrollIndicators(.hidden)
        }
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

private struct AssetCard: View {
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

private struct MostSearchedAssets: View {
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
                    AssetCard(item: item)
                }
            }
            
        }
    }
}


#Preview {
    AssetsView()
}
