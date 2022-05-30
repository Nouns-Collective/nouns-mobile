//
//  CardPlaceholder.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import SwiftUI
import NounsUI

/// A placeholder noun card view when nouns are loading
struct CardPlaceholder: View {
  let count: Int
  
  private let gridLayout = [
    GridItem(.flexible(), spacing: 20),
    GridItem(.flexible(), spacing: 20),
  ]
  
  var body: some View {
    LazyVGrid(columns: gridLayout, spacing: 20) {
      ForEach(1...count, id: \.self) { _ in
        StandardCard(
          header: "---------",
          accessory: {
            Image.mdArrowCorner
          },
          media: {
            Image(R.image.placeholder.name)
              .resizable()
              .scaledToFit()
          },
          content: {
            SafeLabel("------", icon: Image.eth)
              .padding(.top, 8)
          })
          .headerStyle(.small)
          .loading()
      }
    }
  }
}
