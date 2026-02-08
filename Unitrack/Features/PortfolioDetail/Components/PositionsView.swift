//
//  PositionsView.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import SwiftUI

struct PositionView: View {
    let assets: [Asset]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Positions")
                .customFont(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(assets) { item in
                    AssetCard(item: item)
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
                Spacer()
                VStack(alignment: .leading) {
                    Text(item.price)
                        .customFont(.body)
                }
                    
            }
        }
    }
}
