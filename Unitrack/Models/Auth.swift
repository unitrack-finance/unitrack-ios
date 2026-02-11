//
//  Auth.swift
//  Unitrack
//
//  Created by Sylus Abel on 11/02/2026.
//

import Foundation

struct AuthRequest: Codable {
    let email: String
    let password: String
}

struct UserResponse: Codable {
    let id: String
    let email: String
    let subscriptionStatus: String
    let currencyCode: String
}

struct AuthResponse: Codable {
    let token: String
    let refreshToken: String
    let user: UserResponse
}

struct APIErrorResponse: Codable {
    let error: String?
    let message: String?
}

