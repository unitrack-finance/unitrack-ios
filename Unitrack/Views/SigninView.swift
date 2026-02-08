//
//  SigninView.swift
//  Unitrack
//
//  Created by Sylus Abel on 03/02/2026.
//

import SwiftUI
import RiveRuntime

struct SigninView: View {
    @State var email = ""
    @State var password = ""
    @State var isLoading = false
    @Binding var showModal: Bool
    @Binding var isLoggedIn: Bool
    let check = RiveViewModel(fileName: "check", stateMachineName: "State Machine 1")
    let confetti = RiveViewModel(fileName: "confetti", stateMachineName: "State Machine 1")
    
    func logIn() {
        isLoading = true
        
        if email != "" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                check.triggerInput("Check")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                confetti.triggerInput("Trigger explosion")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation {
                    showModal = false
                    isLoggedIn = true
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                check.triggerInput("Error")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                isLoading = false
            }
        }
        
        
    }
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Sign In")
                    .customFont(.largeTitle)
                Text("Connect all your portfolios and track them from one place.")
                    .customFont(.headline)
                    .opacity(0.7)
                
                VStack(alignment: .leading) {
                    Text("Email")
                        .customFont(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("", text: $email)
                        .customTextField()
                        .foregroundStyle(.secondary)
                        .textInputAutocapitalization(.never)
                }
                
                VStack(alignment: .leading) {
                    Text("Password")
                        .customFont(.subheadline)
                        .foregroundColor(.secondary)
                    SecureField("", text: $password)
                        .customTextField(image: Image("Icon Lock"))
                        .foregroundStyle(.secondary)
                }
                
                Button {
                    logIn()
                } label: {
                    Label("Sign In", systemImage: "arrow.right")
                        .customFont(.headline)
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "F77D8E"))
                        .foregroundStyle(.white)
                        .cornerRadius(20, corners: [.topRight, .bottomLeft, .bottomRight])
                        .cornerRadius(8, corners: .topLeft)
                        .shadow(color: Color(hex: "F77D8E").opacity(0.5),
                                radius: 20, x:0, y:10)
                }
                
                HStack {
                    Rectangle().frame(height: 1).opacity(0.3)
                    Text("OR")
                        .customFont(.subheadline)
                        .foregroundStyle(.secondary)
                    Rectangle().frame(height: 1).opacity(0.3)
                }
                Text("Sign up with Email, Apple or Google")
                    .customFont(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Image("Logo Email")
                    Spacer()
                    Image("Logo Apple")
                    Spacer()
                    Image("Logo Google")
                }
            }
            .padding(30)
            .background(.regularMaterial)
            .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: Color("Shadow").opacity(0.3), radius: 5, x: 0, y: 3)
            .shadow(color: Color("Shadow").opacity(0.3), radius: 30, x: 0, y: 30)
            .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(.linearGradient(colors: [.primary.opacity(0.12), .primary.opacity(0.04)], startPoint: .topLeading, endPoint: .bottomTrailing))
            )
            .padding()
            .overlay(
                ZStack {
                    if isLoading {
                        check.view()
                            .frame(width: 100, height: 100)
                            .allowsHitTesting(false)
                    }
                    confetti.view()
                        .scaleEffect(3)
                        .allowsHitTesting(false)
                }
            )
            .fullScreenCover(isPresented: $isLoggedIn) {
                Tabs()
                    .interactiveDismissDisabled(true)
            }
        }
    }
}

#Preview {
    SigninView(showModal: .constant(true), isLoggedIn: .constant(false))
}
