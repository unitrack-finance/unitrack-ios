//
//  CustomFont.swift
//  Unitrack
//
//  Created by Sylus Abel on 02/02/2026.
//

import SwiftUI

struct CustomFont: ViewModifier {
    var textStyle: TextStyle
    var name: String {
        switch textStyle {
        case .title, .largeTitle:
            return "Outfit SemiBold"
        case .footnote, .headline, .subheadline:
            return "Outfit Regular"
        default:
            return "Outfit Regular"
        }
    }
    var size: CGFloat {
        switch textStyle {
        case .title:
            return 24
        case .largeTitle:
            return 28
        case .headline:
            return 16
        case .subheadline:
            return 14
        case .footnote:
            return 12
        default:
            return 20
        }
    }
    var relative: Font.TextStyle {
        switch textStyle {
        case .title:
            return .title
        case .largeTitle:
            return .largeTitle
        case .headline:
            return .headline
        case .subheadline:
            return .subheadline
        case .footnote:
            return .footnote
        default:
            return .body
        }
    }
    
    func body(content: Content) -> some View {
        content.font(.custom(name, size: size, relativeTo: relative))
    }
}

extension View {
    func customFont(_ textStyle: TextStyle) -> some View {
        modifier(CustomFont(textStyle: textStyle))
    }
}

enum TextStyle {
    case title
    case body
    case footnote
    case largeTitle
    case headline
    case subheadline
}
