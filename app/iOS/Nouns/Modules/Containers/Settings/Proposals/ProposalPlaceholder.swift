//
//  ProposalPlaceholder.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-02-21.
//

import SwiftUI

/// A placeholder cell view when proposals are loading
struct ProposalPlaceholder: View {
  let count: Int
  
  private let gridLayout = [
    GridItem(.flexible(), spacing: 20),
    GridItem(.flexible(), spacing: 20),
  ]
  
  var body: some View {
    ForEach(1...count, id: \.self) { _ in
      ProposalPlaceholderRow()
        .loading()
    }
  }
}
