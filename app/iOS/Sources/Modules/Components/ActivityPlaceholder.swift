//
//  ActivityPlaceholder.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-04.
//

import SwiftUI
import UIComponents

/// A placeholder cell view when activities or bids are loading
struct ActivityPlaceholder: View {
  let count: Int
  
  private let gridLayout = [
    GridItem(.flexible(), spacing: 20),
    GridItem(.flexible(), spacing: 20),
  ]
  
  var body: some View {
    ForEach(1...count, id: \.self) { _ in
      ActivityPlaceholderRow()
        .loading()
    }
  }
}
