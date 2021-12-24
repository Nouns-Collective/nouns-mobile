//
//  GradientPickerItem.swift
//  Nouns
//
//  Created by Ziad Tamim on 20.12.21.
//

import SwiftUI
import UIComponents

extension NounPlayground {
  struct GradientPickerItem: View {
    
    @State private var width: CGFloat = 10
    
    private let colors: [Color]
    
    init(colors: [Color]) {
      self.colors = colors
    }
    
    var body: some View {
      LinearGradient(
        colors: colors,
        startPoint: .topLeading,
        endPoint: .bottomTrailing)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .frame(width: width)
        .background(
          GeometryReader { proxy in
            Color.clear
              .onAppear {
                self.width = proxy.size.height
              }
          }
        )
    }
  }
}

private struct GradientSelectedModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .background(Color.black.opacity(0.05))
      .overlay {
        ZStack {
          RoundedRectangle(cornerRadius: 6)
            .stroke(Color.componentNounsBlack, lineWidth: 2)
          Image.checkmark
        }
      }
  }
}

fileprivate extension View {
  
  func selected(_ condition: Bool) -> some View {
    if condition {
      return AnyView(modifier(GradientSelectedModifier()))
    } else {
      return AnyView(self)
    }
  }
}
