//
//  OnChainNounPlaceholderCard.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-18.
//

import SwiftUI
import UIComponents

/// A placeholder noun card view when nouns are loading
struct OnChainNounPlaceholderCard: View {
  var body: some View {
    StandardCard(
      media: {
        Image(R.image.placeholder.name)
          .resizable()
          .scaledToFit()
      },
      smallHeader: "Noun 100",
      accessoryImage: Image.mdArrowCorner,
      detail: {
        SafeLabel("100.00", icon: Image.eth)
      })
  }
}
