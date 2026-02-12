//
//  AgentChatView.swift
//  Unitrack
//

import SwiftUI

// Remaining imports not needed for backend chat

struct Message: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let timestamp = Date()
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
}

struct AgentChatView: View {
    @Environment(\.dismiss) private var dismiss
    private let analyticsService = AnalyticsService.shared
    @State private var inputText = ""
    @State private var messages: [Message] = [
        Message(text: "Hello! I'm Unitrack AI. How can I help you analyze your portfolio today?", isUser: false)
    ]
    @State private var isTyping = false
    @State private var showPrivacyDisclaimer = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.screenBackground.ignoresSafeArea()
                VStack(spacing: 0) {
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(messages) { message in
                                    ChatBubble(message: message)
                                }
                                
                                if isTyping {
                                    TypingIndicator()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(16)
                        }
                        .onChange(of: messages) { oldValue, newValue in
                            withAnimation {
                                proxy.scrollTo(newValue.last?.id, anchor: .bottom)
                            }
                        }
                    }
                    
                    // Input Area
                    inputArea
                }
                
                if showPrivacyDisclaimer {
                    privacyDisclaimerOverlay
                }
            }
            .navigationTitle("Unitrack AI")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
    
    private var inputArea: some View {
        VStack(spacing: 0) {
            Divider().background(Color.textSecondary.opacity(0.1))
            
            HStack(spacing: 12) {
                TextField("Ask about your portfolio...", text: $inputText)
                    .customFont(.body)
                    .padding(12)
                    .background(Color.cardBackgroundSecondary, in: RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(Color.textPrimary)
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32)) // Icon scaling
                        .foregroundStyle(inputText.isEmpty ? Color.textSecondary : .blue)
                }
                .disabled(inputText.isEmpty)
            }
            .padding(16)
            .background(Color.cardBackground)
        }
    }
    
    private var privacyDisclaimerOverlay: some View {
        ZStack {
            // Apply thin material background as requested
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)
                
                Text("AI Privacy Agreement")
                    .customFont(.title2)
                    .foregroundStyle(Color.textPrimary)
                
                Text("By using Unitrack AI, a snapshot of your current holdings (tickers, quantities, and values) will be shared with the AI model to provide accurate insights. No personal banking credentials or identity documents are shared.")
                    .customFont(.body)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Button("I Understand & Agree") {
                    withAnimation {
                        showPrivacyDisclaimer = false
                    }
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
                .background(Color.blue, in: Capsule())
                .foregroundStyle(.white)
                .customFont(.headline)
            }
            .padding(32)
            .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 30))
            .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
            .padding(20)
        }
    }
    
    private func sendMessage() {
        let userText = inputText
        let userMessage = Message(text: userText, isUser: true)
        messages.append(userMessage)
        inputText = ""
        
        isTyping = true
        
        Task {
            do {
                let response = try await analyticsService.chat(message: userText)
                
                await MainActor.run {
                    isTyping = false
                    messages.append(Message(text: response, isUser: false))
                }
            } catch {
                await MainActor.run {
                    isTyping = false
                    messages.append(Message(text: "Sorry, I encountered an error: \(error.localizedDescription)", isUser: false))
                }
            }
        }
    }
}

struct ChatBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            Text(message.text)
                .customFont(.body)
                .padding(12)
                .background(message.isUser ? Color.blue : Color.cardBackground)
                .foregroundStyle(message.isUser ? .white : Color.textPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: message.isUser ? .blue.opacity(0.3) : Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            
            if !message.isUser { Spacer() }
        }
    }
}

struct TypingIndicator: View {
    @State private var dotOffset: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { i in
                Circle()
                    .fill(Color.textSecondary)
                    .frame(width: 6, height: 6)
                    .offset(y: dotOffset)
                    .animation(.easeInOut(duration: 0.5).repeatForever().delay(Double(i) * 0.2), value: dotOffset)
            }
        }
        .padding(12)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 16))
        .onAppear {
            dotOffset = -4
        }
    }
}

#Preview {
    AgentChatView()
}

