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
    
    private init() {}
    
    // MARK: - Portfolio Analysis
    
    func generatePortfolioInsight(portfolioData: String) async throws -> String {
        // We can either call a specific health/insights route or just use chat with a system prompt
        // For now, let's assume the backend health route handles this or use chat
        return try await AnalyticsService.shared.chat(message: "Analyze this portfolio: \(portfolioData)")
    }
    
    // MARK: - Chat Interaction
    
    func streamChat(message: String, history: [ModelContent]) -> AsyncThrowingStream<String, Error> {
        return AsyncThrowingStream { continuation in
            Task {
                do {
                    let response = try await AnalyticsService.shared.chat(message: message)
                    continuation.yield(response)
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
