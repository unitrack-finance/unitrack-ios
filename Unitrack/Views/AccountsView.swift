//
//  AccountsView.swift
//  Unitrack
//
//  Created by Sylus Abel on 05/02/2026.
//

import SwiftUI

struct AccountsView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "link.circle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.blue)
                Text("No Connected Accounts")
                    .font(.title3.weight(.semibold))
                Text("Connect your institutions to sync holdings.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                Button("Connect Account") {}
                    .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("Accounts")
        }
    }
}

#Preview {
    AccountsView()
}
