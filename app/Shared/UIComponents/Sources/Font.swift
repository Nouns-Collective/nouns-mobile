//
//  Font.swift
//  
//
//  Created by Ziad Tamim on 10.11.21.
//

import SwiftUI

/// `GTWalsheim` type safe font.
public enum GTWalsheim: String, CaseIterable {
    case boldOblique = "GT Walsheim Trial Bd Ob"
    case bold = "GT Walsheim Trial Bd"
    case mediumOblique = "GT Walsheim Trial Md Ob"
    case medium = "GT Walsheim Trial Md"
    case regularOblique = "GT Walsheim Trial Rg Ob"
    case regular = "GT Walsheim Trial Rg"
}

internal enum FontType: String {
    case `true` = "ttf"
    case `open` = "otf"
}

extension Font {
    
    public static func custom(_ font: GTWalsheim, relativeTo style: Font.TextStyle) -> Font {
        custom(font.rawValue, size: style.size, relativeTo: style)
    }
    
    public static func custom(_ font: GTWalsheim, size: CGFloat) -> Font {
        custom(font.rawValue, size: size)
    }
    
    internal static func registerFont(bundle: Bundle, name: String, type: FontType) {
        guard let fontURL = bundle.url(forResource: name, withExtension: type.rawValue),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider)
        else {
            fatalError("⚠️ Couldn't register font with name: \(name)")
        }
        
        var error: Unmanaged<CFError>?
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
}

public extension Font.TextStyle {
    
    /// Relative sizes to the text styles to match the UI Context.
    var size: CGFloat {
        switch self {
        case .largeTitle:
            return 52
            
        case .title:
            return 48
            
        case .title2:
            return 36
            
        case .title3:
            return 24
            
        case .headline, .body:
            return 18
            
        case .subheadline, .callout:
            return 17
            
        case .footnote:
            return 15
            
        case .caption, .caption2:
            return 13
            
        @unknown default:
            return 8
        }
    }
}
