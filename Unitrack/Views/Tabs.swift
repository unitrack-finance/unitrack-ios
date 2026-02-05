//
//  Tabs.swift
//  Unitrack
//
//  Created by Sylus Abel on 05/02/2026.
//

import SwiftUI

enum AppTabs {
    case home, portfolio, profile, search
}

struct Tabs: View {
    @State var selectedTab: AppTabs = .home
    @State var searchText: String = ""
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house", value: .home) {
                Color.red.opacity(0.5).ignoresSafeArea()
            }
            Tab("Portfolio", systemImage: "clock", value: .portfolio) {
                Color.pink.opacity(0.5).ignoresSafeArea()
            }
            Tab("Profile", systemImage: "gearshape", value: .profile) {
                Color.purple.opacity(0.5).ignoresSafeArea()
            }
            
            Tab(value: .search, role: .search) {
                NavigationStack {
                    List {
                        Text("Search screen")
                    }
                    .navigationTitle("Search")
                    .searchable(text: $searchText)
                }
            }
           
            
        }    }
}

#Preview {
    Tabs()
}
