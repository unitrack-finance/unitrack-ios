//
//  AIService.swift
//  Unitrack
//
//  Created by Sylus Abel on 10/02/2026.
//

import Foundation
import GoogleGenerativeAI

@MainActor
class AIService {
    static let shared = AIService()
    
    private let model: GenerativeModel
    
    // We use a simple chat history for context
    private(set) var chatHistory: [ChatHistoryItem] = []
    
    private init() {
        // Initialize Gemini with the API Key from Configuration
        // Using gemini-1.5-flash for speed and efficiency
        self.model = GenerativeModel(
            name: "gemini-1.5-flash",
            apiKey: Configuration.APIKeys.gemini
        )
    }
    
    // MARK: - Portfolio Analysis
    
    /// Generates a proactive insight based on a portfolio snapshot
    func generatePortfolioInsight(portfolioData: String) async throws -> String {
        let prompt = """
        You are Unitrack AI, a professional financial analyst.
        Analyze this portfolio snapshot and provide ONE concise, actionable insight (max 20 words).
        Focus on risk, diversification, or sector concentration.
        
        Portfolio Snapshot:
        \(portfolioData)
        """
        
        let response = try await model.generateContent(prompt)
        return response.text ?? "Unable to generate insight."
    }
    
    // MARK: - Chat Interaction
    
    /// Sends a user message to the AI and streams the response
    func streamChat(message: String, history: [ModelContent]) -> AsyncThrowingStream<String, Error> {
        let chat = model.startChat(history: history)
        
        return AsyncThrowingStream { continuation in
            Task {
                do {
                    let stream = chat.sendMessageStream(message)
                    for try await chunk in stream {
                        if let text = chunk.text {
                            continuation.yield(text)
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}

// Helper for UI to map chat messages to Gemini's ModelContent
extension Message {
    var asModelContent: ModelContent {
        return ModelContent(role: isUser ? "user" : "model", parts: [ModelContent.Part.text(text)])
    }
}

struct ChatHistoryItem {
    let role: String
    let message: String
}
