//
//  Contained.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-11-01.
//

import SwiftUI

/// A label style that shows has a rounded rectangle as it's background
/// with a matching background and label colour.
public struct ContainedLabel: ViewModifier {
    static public let defaultPadding = EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
    
    private let textColor: Color
    
    private let backgroundColor: Color
    
    private let padding: EdgeInsets
    
    public init(textColor: Color, backgroundColor: Color, padding: EdgeInsets) {
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.padding = padding
    }

    public func body(content: Content) -> some View {
        content
            .padding(.vertical, 4)
            .padding(.horizontal, 10)
            .foregroundColor(textColor)
            .background(backgroundColor)
            .clipShape(Capsule())
    }
}

extension Label {
    /// A view modifier that adds a rounded background with a specific color to a label
    ///
    /// To apply the contained style, apply the contained modifier
    /// to a label view:
    ///
    ///     Label("Sun", systemImage: "sun.max")
    ///         .contained(textColor: .white, backgroundColor: .blue)
    ///
    /// - Parameter color: The background and foreground color of the contained label
    /// - Parameter padding: The padding to apply to each edge of the resulting contained label
    ///
    public func contained(textColor: Color, backgroundColor: Color, padding: EdgeInsets = ContainedLabel.defaultPadding) -> some View {
        modifier(ContainedLabel(textColor: textColor, backgroundColor: backgroundColor, padding: padding))
    }
}

extension Text {
    /// A view modifier that adds a rounded background with a specific color to a text view
    ///
    /// To apply the contained style, apply the contained modifier
    /// to a text view:
    ///
    ///     Text("Hello")
    ///         .contained(textColor: .white, backgroundColor: .blue)
    ///
    /// - Parameter color: The background and foreground color of the contained text
    /// - Parameter padding: The padding to apply to each edge of the resulting contained text
    ///
    public func contained(textColor: Color, backgroundColor: Color, padding: EdgeInsets = ContainedLabel.defaultPadding) -> some View {
        modifier(ContainedLabel(textColor: textColor, backgroundColor: backgroundColor, padding: padding))
    }
}
