//
//  ConditionalSpacer.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-24.
//

import SwiftUI

/// A spacer view that is only show if a condition is true
struct ConditionalSpacer: View {
  private let showSpacer: Bool
  
  init(_ condition: Bool) {
    self.showSpacer = condition
  }
  
  var body: some View {
    if showSpacer {
      Spacer()
    }
  }
}
