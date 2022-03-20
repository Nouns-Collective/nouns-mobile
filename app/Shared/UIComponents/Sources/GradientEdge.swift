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
  
  func body(content: Content) -> some View {
    ZStack(alignment: .top) {
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
  
  /// Adds a gradient view to the top of a view, with a solid color at the top of the gradient view
  /// and fades out by the bottom of the gradient view.
  public func addGradientTopEdge(_ color: Color) -> some View {
    modifier(GradientEdge(color: color))
  }
}
