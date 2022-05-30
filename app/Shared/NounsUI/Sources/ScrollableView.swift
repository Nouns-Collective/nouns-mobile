//
//  File.swift
//  
//
//  Created by Mohammed Ibrahim on 2022-02-13.
//

import SwiftUI

internal struct ScrollableView: ViewModifier {
  
  func body(content: Content) -> some View {
    ScrollView(.vertical, showsIndicators: false) {
      content
    }
  }
}

public extension View {
  
  /// A view extension that makes the content of the view scrollable given a specified condition is `true`
  func scrollable(_ condition: Bool) -> some View {
    if condition {
      return AnyView(modifier(ScrollableView()))
    } else {
      return AnyView(self)
    }
  }
}
