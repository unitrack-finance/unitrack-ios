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
    @State var showModal = false
    @State var isLoggedIn = false

    var body: some View {
        NavigationStack {
            ZStack {
                background
                
                content
                    .offset(y: showModal ? 50 : 0)
                
                Color("Shadow")
                    .opacity(showModal ? 0.4 : 0)
                    .ignoresSafeArea()
                
                if showModal {
                    SigninView(showModal: $showModal, isLoggedIn: $isLoggedIn)
                        .transition(.move(edge: .top)
                            .combined(with: .opacity)
                        )
                        .overlay(
                            Button {
                                withAnimation(.spring()) {
                                    showModal = false
                                }
                            } label: {
                                Image(systemName: "xmark")
                                    .frame(width: 36, height: 36)
                                    .foregroundColor(.black)
                                    .background(.white)
                                    .mask(Circle())
                                    .shadow(color:
                                                Color("Shadow").opacity(0.3),
                                            radius: 5, x:0, y:5
                                    )
                            }
                                .frame(maxHeight: .infinity,
                                       alignment: .bottom
                                      )
                            
                        )
                        .zIndex(1)
                }
            }
            .fullScreenCover(isPresented: $isLoggedIn) {
                Tabs()
                    .interactiveDismissDisabled(true)
            }
        }
    }
    
    var content: some View {
     
        VStack(alignment: .leading, spacing: 12) {
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
                        .foregroundColor(Color(hex: "F77D8E"))
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        withAnimation(.spring()){
                            showModal = true
                        }
                    }
                }
            
            Text(" Messy portfolios? Unify your assets with Unitrack.")
                .customFont(.footnote)
                .opacity(0.7)
        }
        .padding(40)
        .padding(.top, 40)
        
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
