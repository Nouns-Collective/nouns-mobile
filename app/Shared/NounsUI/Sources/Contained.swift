// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

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

extension View {
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
