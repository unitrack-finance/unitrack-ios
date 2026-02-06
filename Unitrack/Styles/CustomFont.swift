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
        case .largeTitle, .prominentTitle, .title, .title2, .title3, .headline:
            return "Outfit SemiBold"
        case .body, .callout, .subheadline:
            return "Outfit Regular"
        case .footnote, .caption, .caption2:
            return "Outfit Regular"
        }
    }
    var size: CGFloat {
        switch textStyle {
        case .prominentTitle:
            return 44
        case .largeTitle:
            return 34
        case .title:
            return 28
        case .title2:
            return 22
        case .title3:
            return 20
        case .headline:
            return 17
        case .body:
            return 17
        case .callout:
            return 16
        case .subheadline:
            return 15
        case .footnote:
            return 13
        case .caption:
            return 12
        case .caption2:
            return 11
        }
    }
    var relative: Font.TextStyle {
        switch textStyle {
        case .prominentTitle:
            return .largeTitle
        case .largeTitle:
            return .largeTitle
        case .title:
            return .title
        case .title2:
            return .title2
        case .title3:
            return .title3
        case .headline:
            return .headline
        case .body:
            return .body
        case .callout:
            return .callout
        case .subheadline:
            return .subheadline
        case .footnote:
            return .footnote
        case .caption:
            return .caption
        case .caption2:
            return .caption2
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
    case prominentTitle  // 44pt - Hero numbers
    case largeTitle      // 34pt - Screen titles
    case title           // 28pt - Section headers
    case title2          // 22pt - Card titles
    case title3          // 20pt - Subsection headers
    case headline        // 17pt - Emphasized body
    case body            // 17pt - Primary content
    case callout         // 16pt - Secondary content
    case subheadline     // 15pt - Tertiary content
    case footnote        // 13pt - Timestamps, labels
    case caption         // 12pt - Small labels
    case caption2        // 11pt - Smallest text
}
