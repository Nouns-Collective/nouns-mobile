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

/// A view modifier to add a gradient view edge to the top of a view
struct GradientEdge: ViewModifier {
  
  let color: Color
  
  let edge: Edge
  
  private var alignment: Alignment {
    switch edge {
    case .bottom:
      return .bottom
    case .top:
      return .top
    case .leading:
      return .leading
    case .trailing:
      return .trailing
    }
  }
  
  func body(content: Content) -> some View {
    ZStack(alignment: alignment) {
      content

      Gradient(
        colors: [color, color.opacity(0)],
        startPoint: .center,
        endPoint: .bottom
      )
        .frame(maxWidth: .infinity)
        .frame(height: 60)
    }
  }
}

extension View {
  
  /// Adds a gradient view to the edge of a view, with a solid color at the edge of the screen's bounds
  /// and fades out closer to the center of the screen's bounds
  public func overlay(_ color: Color, edge: Edge) -> some View {
    modifier(GradientEdge(color: color, edge: edge))
  }
}
