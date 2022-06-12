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

extension View {
    /// Applies a corner radius to any specified set of corners to any view
    ///
    ///
    /// - Parameters:
    ///   - radius: The desired corner radius for the view
    ///   - corners: The corners to apply the corner radius too, exclusively. 
    public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    
    /// Sets the view's to a specified border with corner radious.
    /// - Parameters:
    ///   - content: The color or gradient with which to stroke this shape.
    ///   - lineWidth: The width of the stroke that outlines this shape.
    ///   - fillColor: Sets the view’s background to a specified style.
    ///   - cornerRadius: the specified corner radius.
    public func border<S>(
        _ strokeStyle: S,
        lineWidth: CGFloat,
        fillColor: Color = .white,
        cornerRadius: CGFloat = 1
    ) -> some View  where S: ShapeStyle {
        background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(strokeStyle, lineWidth: lineWidth)
                .background(fillColor))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}
