//
//  CountryCode.swift
//  Unitrack
//

import Foundation

struct CountryCode: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let code: String
    let flag: String
}

extension CountryCode {
    static let samples: [CountryCode] = [
        .init(name: "Austria", code: "+43", flag: "🇦🇹"),
        .init(name: "Belgium", code: "+32", flag: "🇧🇪"),
        .init(name: "Bulgaria", code: "+359", flag: "🇧🇬"),
        .init(name: "Cyprus", code: "+357", flag: "🇨🇾"),
        .init(name: "Czech Republic", code: "+420", flag: "🇨🇿"),
        .init(name: "Germany", code: "+49", flag: "🇩🇪"),
        .init(name: "Denmark", code: "+45", flag: "🇩🇰"),
        .init(name: "Spain", code: "+34", flag: "🇪🇸"),
        .init(name: "Estonia", code: "+372", flag: "🇪🇪"),
        .init(name: "Croatia", code: "+385", flag: "🇭🇷")
    ]
}
