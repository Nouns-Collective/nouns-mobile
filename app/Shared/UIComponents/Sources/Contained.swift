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
    static public let defaultPadding = EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
    
    private let color: Color
    private let padding: EdgeInsets
    
    public init(color: Color, padding: EdgeInsets) {
        self.padding = padding
        self.color = color
    }

    public func body(content: Content) -> some View {
        content
            .foregroundColor(color)
            .padding(padding)
            .background(color.opacity(0.15))
            .cornerRadius(4)
    }
}

extension Label {
    /// A view modifier that adds a rounded background with a specific color to a label
    ///
    /// To apply the contained style, apply the contained modifier
    /// to a label view:
    ///
    ///     Label("Sun", systemImage: "sun.max")
    ///         .contained(color: .red)
    ///
    /// - Parameter color: The background and foreground color of the contained label
    /// - Parameter padding: The padding to apply to each edge of the resulting contained label
    ///
    public func contained(color: Color, padding: EdgeInsets = ContainedLabel.defaultPadding) -> some View {
        modifier(ContainedLabel(color: color, padding: padding))
    }
}

extension Text {
    /// A view modifier that adds a rounded background with a specific color to a text view
    ///
    /// To apply the contained style, apply the contained modifier
    /// to a text view:
    ///
    ///     Text("Hello")
    ///         .contained(color: .red)
    ///
    /// - Parameter color: The background and foreground color of the contained text
    /// - Parameter padding: The padding to apply to each edge of the resulting contained text
    ///
    public func contained(color: Color, padding: EdgeInsets = ContainedLabel.defaultPadding) -> some View {
        modifier(ContainedLabel(color: color, padding: padding))
    }
}
