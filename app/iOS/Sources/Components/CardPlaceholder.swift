//
//  CardPlaceholder.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import SwiftUI
import UIComponents

/// A placeholder noun card view when nouns are loading
struct CardPlaceholder: View {
  let count: Int
  
  private let gridLayout = [
    GridItem(.flexible(), spacing: 20),
    GridItem(.flexible(), spacing: 20),
  ]
  
  var body: some View {
    LazyVGrid(columns: gridLayout) {
      ForEach(1...count, id: \.self) { _ in
        StandardCard(
          media: {
            Image(R.image.placeholder.name)
              .resizable()
              .scaledToFit()
          },
          smallHeader: "_______",
          accessoryImage: Image.mdArrowCorner,
          detail: {
            SafeLabel("_____", icon: Image.eth)
          })
          .skeleton()
      }
    }
  }
}
