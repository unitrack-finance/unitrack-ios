//
//  OnboardingView.swift
//  Unitrack
//
//  Created by Sylus Abel on 28/01/2026.
//

import SwiftUI
import RiveRuntime

struct OnboardingView: View {
    let button = RiveViewModel(fileName: "button")

    var body: some View {
        ZStack {
            background
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Unified Portfolio Tracker")
                    .font(.custom("Outfit SemiBold", size: 60, relativeTo: .largeTitle))
                    .frame(width: 260, alignment: .leading)
                
                Text("Unitrack unifies portfolio tracking: real-time updates, custom real estate/fixed-income entries, alerts, premium risk analysis. One portfolio to track them all.")
                    .customFont(.body)
                    .opacity(0.7)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                button.view()
                    .frame(width: 236, height: 64)
                    .overlay(
                        Label("Start Tracking", systemImage:
                            "arrow.forward")
                            .offset(x: 4, y: 4)
                            .font(.headline)
                    )
                    .background(
                        Color.black
                            .cornerRadius(30)
                            .blur(radius: 10)
                            .opacity(0.3)
                            .offset(y: 10)
                    )
                    .onTapGesture {
                        button.play(animationName: "active")
                    }
                
                Text(" Messy portfolios? Unify your assets with Unitrack.")
                    .customFont(.footnote)
                    .opacity(0.7)
            }
            .padding(40)
            .padding(.top, 40)
        }

        }
    var background: some View {
        RiveViewModel(fileName: "shapes").view()
            .ignoresSafeArea()
            .blur(radius: 30)
            .background(
                Image("Spline")
                    .blur(radius: 50)
                    .offset(x:200,y:100)
        )
    }
    }
    
    struct OnboardingView_Preview: PreviewProvider {
        static var previews: some View {
            OnboardingView()
        }
    }
