//
//  Constants.swift
//  Unitrack
//
//  Created by Sylus Abel on 11/02/2026.
//

import Foundation

struct Constants {
    static let baseURL = URL(string: "https://unitrack.definetlynotlocalhost.space/v1")!
    
    struct URLs {
        static let auth = baseURL.appendingPathComponent("auth")
        static let login = auth.appendingPathComponent("login")
        static let signup = auth.appendingPathComponent("signup")
        static let refresh = auth.appendingPathComponent("refresh")
        static let logout = auth.appendingPathComponent("logout")
        static let profile = auth.appendingPathComponent("profile")
        
        static let plaid = baseURL.appendingPathComponent("connections/plaid")
        static let wallet = baseURL.appendingPathComponent("connections/wallet")
        
        static let portfolio = baseURL.appendingPathComponent("portfolio")
        static let assetsManual = baseURL.appendingPathComponent("assets/manual")
        static let market = baseURL.appendingPathComponent("market")
        static let analytics = baseURL.appendingPathComponent("analytics")
    }
}