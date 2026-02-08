//
//  AccountsView.swift
//  Unitrack
//
//  Created by Sylus Abel on 05/02/2026.
//

import SwiftUI

struct AssetsView: View {
    @State var searchTerm = ""
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
                        
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 50)
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    AssetsView()
}
