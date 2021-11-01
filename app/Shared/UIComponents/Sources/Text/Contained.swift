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
    static let defaultPadding = EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
 
    let color: Color
    let padding: EdgeInsets
    
    init(color: Color, padding: EdgeInsets) {
        self.padding = padding
        self.color = color
    }

    public func body(content: Content) -> some View {
        content
            .foregroundColor(color)
            .padding(padding)
            .background(color.opacity(0.25))
            .cornerRadius(8)
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
    func contained(color: Color, padding: EdgeInsets = ContainedLabel.defaultPadding) -> some View {
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
    func contained(color: Color, padding: EdgeInsets = ContainedLabel.defaultPadding) -> some View {
        modifier(ContainedLabel(color: color, padding: padding))
    }
}

struct ContainedLabel_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("This is some sample text")
                .contained(color: .green)
            
            Text("This is some sample text")
                .contained(color: .blue)
            
            Text("00:00:88")
                .contained(color: .red)
            
            Label("Sun", systemImage: "sun.max")
                .contained(color: .orange)
        }
    }
}
