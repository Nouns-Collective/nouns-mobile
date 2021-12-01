//
//  ActivityIndicator.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents

/// An animated Noun activity indicator.
extension View {
  
  func activityIndicator(isPresented: Bool) -> some View {
    modifier(ActivityIndicator(isPresented: isPresented))
  }
}

struct ActivityIndicator: ViewModifier {
  let isPresented: Bool
  
  func body(content: Content) -> some View {
    isPresented ? AnyView(placeholder) : AnyView(content)
  }
  
  private var placeholder: some View {
    VStack {
      GIFImage("noun-activity")
        .frame(height: 250)
    }
    .frame(maxHeight: .infinity)
  }
}
