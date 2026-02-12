//
//  DashboardHeader.swift
//  Unitrack
//
//  Created by Sylus Abel on 08/02/2026.
//

import SwiftUI

struct DashboardHeader: View {
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome")
                    .customFont(.title2)
              
                Text(Date().formatted(.dateTime.day().month(.wide).year()))
                    .customFont(.caption)
                   
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                IconButton(icon: "gearshape", action: {})
                IconButton(icon: "bell", action: {})
                
                Circle()
                    .fill(Color.cardBackgroundSecondary)
                    .frame(width: 40, height: 40)
                    .overlay {
                        Image(systemName: "person.fill")
            
                    }
            }
        }
        .padding(.vertical, 8)
    }
}
