//
//  Configuration.swift
//  Unitrack
//

import Foundation

enum Configuration {
    enum APIKeys {
        static var revenueCat: String {
            return Bundle.main.object(forInfoDictionaryKey: "REVENUE_CAT_TEST_API_KEY") as? String ?? ""
        }
        
        static var gemini: String {
            return Bundle.main.object(forInfoDictionaryKey: "GEMINI_API_KEY") as? String ?? ""
        }
    }
}
