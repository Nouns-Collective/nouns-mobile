//
//  GradientEdge.swift
//  
//
//  Created by Mohammed Ibrahim on 2022-03-20.
//

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
