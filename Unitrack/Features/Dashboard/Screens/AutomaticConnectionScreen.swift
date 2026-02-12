import SwiftUI
import LinkKit
import UIKit

struct AutomaticConnectionScreen: SwiftUI.View {
    let institution: Institution
    @SwiftUI.Environment(\.dismiss) private var dismiss
    
    @State private var linkToken: String?
    @State private var handler: Handler?
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 32) {
            // Visual Header
            VisualConnectionHeader(institution: institution)
                .padding(.top, 40)
            
            VStack(spacing: 12) {
                Text("Automatic connection")
                    .customFont(.title2)
                
                Text("Securely import your \(institution.name) account. All data is encrypted and stored by Plaid")
                    .customFont(.body)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            if let error = errorMessage {
                Text(error)
                    .customFont(.caption)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.red.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
            }
            
            Spacer()
            
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            } else {
                // Continue Button
                Button(action: {
                    if let handler = handler {
                        if let topVC = UIApplication.topViewController() {
                            handler.open(presentUsing: .viewController(topVC))
                        }
                    } else {
                        Task { await fetchAndOpen() }
                    }
                }) {
                    Text(handler != nil ? "Open Plaid Link" : "Connect Account")
                        .customFont(.headline)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .padding(.horizontal, 20)
            }
            
            Text("By continuing, you agree to Plaid's Privacy Policy")
                .customFont(.caption)
                .foregroundStyle(Color.textSecondary)
                .padding(.bottom, 20)
        }
        .background(Color.screenBackground)
        .navigationTitle(institution.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task { await fetchLinkToken() }
        }
    }
    
    private func fetchLinkToken() async {
        guard linkToken == nil else { return }
        isLoading = true
        do {
            let token = try await PlaidService.shared.fetchLinkToken()
            self.linkToken = token
            createHandler(token: token)
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "Failed to initialize Plaid. Please try again."
        }
    }
    
    private func fetchAndOpen() async {
        await fetchLinkToken()
        if let handler = handler {
            if let topVC = UIApplication.topViewController() {
                handler.open(presentUsing: .viewController(topVC))
            }
        }
    }
    
    private func createHandler(token: String) {
        var config = LinkTokenConfiguration(token: token) { success in
            handleSuccess(publicToken: success.publicToken, metadata: success.metadata)
        }
        
        config.onExit = { exit in
            if let error = exit.error {
                print("Plaid exit error: \(error)")
                errorMessage = "Connection was interrupted."
            }
        }
        
        let result = Plaid.create(config)
        switch result {
        case .success(let handler):
            self.handler = handler
        case .failure(let error):
            print("Plaid creation failure: \(error)")
            errorMessage = "Failed to create Plaid handler."
        }
    }
    
    private func handleSuccess(publicToken: String, metadata: SuccessMetadata) {
        isLoading = true
        Task {
            do {
                let institutionId = metadata.institution.id
                let accountIds = metadata.accounts.map { $0.id }
                
                try await PlaidService.shared.exchangePublicToken(
                    publicToken: publicToken,
                    institutionId: institutionId,
                    accountIds: accountIds
                )
                
                await MainActor.run {
                    isLoading = false
                    dismiss()
                    // Trigger dashboard refresh if needed (e.g., via notification)
                    NotificationCenter.default.post(name: NSNotification.Name("RefreshDashboard"), object: nil)
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "Failed to complete connection. Please contact support."
                }
            }
        }
    }
}

struct CheckboxView: View {
    @Binding var isOn: Bool
    let label: String
    var infoAction: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: { isOn.toggle() }) {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.textTertiary, lineWidth: 2)
                    .frame(width: 24, height: 24)
                    .background(isOn ? Color.white : Color.clear, in: RoundedRectangle(cornerRadius: 4))
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.black)
                            .opacity(isOn ? 1 : 0)
                    )
            }
            .buttonStyle(.plain)
            
            Text(label)
                .customFont(.body)
                .foregroundStyle(Color.textPrimary)
            
            if let infoAction = infoAction {
                Button(action: infoAction) {
                    Image(systemName: "info.circle")
                        .foregroundStyle(Color.textTertiary)
                }
            }
            
            Spacer()
        }
    }
}

// Reusable Header Component
struct VisualConnectionHeader: View {
    let institution: Institution
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.cardBackgroundSecondary)
                .frame(width: 72, height: 72)
                .overlay(
                    Image(systemName: institution.logoName)
                        .font(.system(size: 28))
                )
            
            HStack(spacing: 4) {
                ForEach(0..<3) { _ in
                    Circle()
                        .fill(Color.textTertiary.opacity(0.3))
                        .frame(width: 4, height: 4)
                }
                Image(systemName: "chevron.right")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(Color.textTertiary.opacity(0.5))
            }
            
            Circle()
                .stroke(Color.textTertiary.opacity(0.5), lineWidth: 1)
                .frame(width: 72, height: 72)
                .overlay(
                    Text("g") // Placeholder for app icon
                        .font(.system(size: 32, design: .serif))
                )
        }
    }
}

#Preview {
    NavigationStack {
        AutomaticConnectionScreen(institution: Institution(name: "Trade Republic", logoName: "building.columns.fill", category: .popular))
            .preferredColorScheme(.dark)
    }
}
extension UIApplication {
    static func topViewController(base: UIViewController? = {
        if let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
           let window = scene.windows.first(where: { $0.isKeyWindow }) {
            return window.rootViewController
        }
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController
    }()) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return topViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

