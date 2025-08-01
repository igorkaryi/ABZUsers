//
//  AppFont.swift
//  ABZUsers
//
//  Created by Igor Karyi on 30.07.2025.
//

import SwiftUI

enum AppFont: String {
    case nunitoSans = "NunitoSans"
}

enum FontWeight: String {
    case thin = "Thin"
    case extraLight = "ExtraLight"
    case light = "Light"
    case regular = "Regular"
    case medium = "Medium"
    case semiBold = "SemiBold"
    case bold = "Bold"
    case extraBold = "ExtraBold"
    case black = "Black"
}

struct FontHelper {
    
    static func fontName(for font: AppFont, weight: FontWeight) -> String {
        return "\(font.rawValue)-\(weight.rawValue)"
    }

    static func convertToSwiftUIFontWeight(_ weight: FontWeight) -> Font.Weight {
        switch weight {
        case .thin:
            return .thin
        case .extraLight:
            return .ultraLight
        case .light:
            return .light
        case .regular:
            return .regular
        case .medium:
            return .medium
        case .semiBold:
            return .semibold
        case .bold:
            return .bold
        case .extraBold:
            return .heavy
        case .black:
            return .black
        }
    }
}

extension Font {
    
    private static var fontCache: [String: Font] = [:]

    static func appFont(font: AppFont = .nunitoSans,
                        weight: FontWeight,
                        size: CGFloat) -> Font {
        
        let fontName = FontHelper.fontName(for: font, weight: weight)
        let cacheKey = "\(fontName)-\(size)"

        if let cachedFont = fontCache[cacheKey] {
            return cachedFont
        }

        if UIFont(name: fontName, size: size) != nil {
            let customFont = Font.custom(fontName, size: size, relativeTo: .body)
            fontCache[cacheKey] = customFont
            return customFont
        } else {
            let systemFont = Font.system(size: size, weight: FontHelper.convertToSwiftUIFontWeight(weight))
            fontCache[cacheKey] = systemFont
            return systemFont
        }
    }
}
