//
//  GStack.swift
//  Nouns
//
//  Created by Ziad Tamim on 11.11.21.
//

import SwiftUI

/// `Background Gradient` 
extension View {
  
  func background<Gradient>(_ gradient: Gradient) -> some View where Gradient: View {
    modifier(Background(gradient))
  }
}

struct Background<Gradient>: ViewModifier where Gradient: View {
  private let gradient: Gradient
  
  init(_ gradient: Gradient) {
    self.gradient = gradient
  }
  
  func body(content: Content) -> some View {
    ZStack {
      gradient
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
      
      content
    }
  }
}
