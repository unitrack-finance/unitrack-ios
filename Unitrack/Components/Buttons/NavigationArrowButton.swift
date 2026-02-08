//
//  NavigationArrowButton.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import SwiftUI

struct NavigationArrowButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.up.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.black)
                .frame(width: 32, height: 32)
                .background(Color.white, in: Circle())
        }
    }
}
