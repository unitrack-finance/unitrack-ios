//
//  OnboardingView.swift
//  Unitrack
//
//  Created by Sylus Abel on 28/01/2026.
//

import SwiftUI
import RiveRuntime

struct OnboardingView: View {
    
    
    private let riveViewModel = RiveViewModel(fileName: "shapes")
    
    
    var body: some View {
        
        riveViewModel.view()
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
