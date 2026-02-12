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
    @State var isRegistering = false
    @State var isLoading = false
    @State private var isShowingErrorAnimation = false
    @State private var showingErrorAlert = false
    @State private var errorMessage: String = ""
    @Binding var showModal: Bool
    @Binding var isLoggedIn: Bool
    let check = RiveViewModel(fileName: "check", stateMachineName: "State Machine 1")
    let confetti = RiveViewModel(fileName: "confetti", stateMachineName: "State Machine 1")
    
    func authenticate() {
        isLoading = true
        check.triggerInput("Check")

        guard !email.isEmpty, !password.isEmpty else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                check.triggerInput("Error")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                isLoading = false
            }
            return
        }

        Task {
            let authRequest = AuthRequest(email: email, password: password)
            do {
                let response: AuthResponse
                if isRegistering {
                    response = try await AuthService.shared.signup(request: authRequest)
                } else {
                    response = try await AuthService.shared.login(request: authRequest)
                }

                print("Auth successful:", response)

                isLoading = false
                confetti.triggerInput("Trigger explosion")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        showModal = false
                        isLoggedIn = true
                    }
                }
            } catch {
                isLoading = false
                isShowingErrorAnimation = true
                check.triggerInput("Error")
                errorMessage = readableMessage(from: error)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    showingErrorAlert = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    isShowingErrorAnimation = false
                }
            }
        }
    }
    
    func readableMessage(from error: Error) -> String {
        if let decodingError = error as? DecodingError {
            switch decodingError {
            case .dataCorrupted(let ctx):
                return "We received invalid data. \(ctx.debugDescription)"
            case .keyNotFound(let key, let ctx):
                return "Missing field: \(key.stringValue). \(ctx.debugDescription)"
            case .typeMismatch(_, let ctx):
                return "Unexpected data type. \(ctx.debugDescription)"
            case .valueNotFound(_, let ctx):
                return "Expected value was missing. \(ctx.debugDescription)"
            @unknown default:
                return "Unexpected response format."
            }
        }
        let message = (error as NSError).localizedDescription
        return message.isEmpty ? "Something went wrong. Please try again." : message
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text(isRegistering ? "Sign Up" : "Sign In")
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
                    authenticate()
                } label: {
                    Label(isRegistering ? "Sign Up" : "Sign In", systemImage: "arrow.right")
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
                
                Text(isRegistering ? "Sign up with Email, Apple or Google" : "Sign in with Email, Apple or Google")
                    .customFont(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Image("Logo Email")
                    Spacer()
                    Image("Logo Apple")
                    Spacer()
                    Image("Logo Google")
                }
                
                Button {
                    withAnimation(.spring()) {
                        isRegistering.toggle()
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(isRegistering ? "Already have an account?" : "Don't have an account?")
                            .customFont(.subheadline)
                            .foregroundColor(.secondary)
                        Text(isRegistering ? "Sign In" : "Sign Up")
                            .customFont(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "F77D8E"))
                    }
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
                    if isLoading || isShowingErrorAnimation {
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
            .alert(isRegistering ? "Sign Up Failed" : "Sign In Failed", isPresented: $showingErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage.isEmpty ? "Something went wrong. Please try again." : errorMessage)
            }
        }
    }
}

#Preview {
    SigninView(showModal: .constant(true), isLoggedIn: .constant(false))
}

