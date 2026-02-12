//
//  AuthService.swift
//  Unitrack
//
//  Created by Sylus Abel on 12/02/2026.
//

import Foundation

class AuthService {
    static let shared = AuthService()
    private let client = HTTPClient()
    
    private init() {}
    
    func login(request: AuthRequest) async throws -> AuthResponse {
        let response: AuthResponse = try await client.post(to: Constants.URLs.login, body: request, requiresAuth: false)
        TokenManager.shared.token = response.token
        TokenManager.shared.refreshToken = response.refreshToken
        return response
    }
    
    func signup(request: AuthRequest) async throws -> AuthResponse {
        let response: AuthResponse = try await client.post(to: Constants.URLs.signup, body: request, requiresAuth: false)
        TokenManager.shared.token = response.token
        TokenManager.shared.refreshToken = response.refreshToken
        return response
    }
    
    func refresh() async throws -> AuthResponse {
        guard let refreshToken = TokenManager.shared.refreshToken else {
            throw URLError(.userAuthenticationRequired)
        }
        let payload = ["refreshToken": refreshToken]
        let response: AuthResponse = try await client.post(to: Constants.URLs.refresh, body: payload, requiresAuth: false)
        TokenManager.shared.token = response.token
        TokenManager.shared.refreshToken = response.refreshToken
        return response
    }
    
    func logout() async throws {
        let payload = ["refreshToken": TokenManager.shared.refreshToken ?? ""]
        _ = try await client.post(to: Constants.URLs.logout, body: payload) as [String: String]
        TokenManager.shared.clear()
    }
    
    func getProfile() async throws -> UserResponse {
        return try await client.get(from: Constants.URLs.profile)
    }
}
