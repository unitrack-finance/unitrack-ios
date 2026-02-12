//
//  TokenManager.swift
//  Unitrack
//
//  Created by Sylus Abel on 12/02/2026.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    
    private let tokenKey = "com.unitrack.auth.token"
    private let refreshTokenKey = "com.unitrack.auth.refreshToken"
    
    private init() {}
    
    var token: String? {
        get { UserDefaults.standard.string(forKey: tokenKey) }
        set { UserDefaults.standard.set(newValue, forKey: tokenKey) }
    }
    
    var refreshToken: String? {
        get { UserDefaults.standard.string(forKey: refreshTokenKey) }
        set { UserDefaults.standard.set(newValue, forKey: refreshTokenKey) }
    }
    
    func clear() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: refreshTokenKey)
    }
}
