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
  
  var body: some View {
    ForEach(1...count, id: \.self) { _ in
      StandardCard(
        header: "_______",
        accessory: {
          Image.mdArrowCorner
        },
        media: {
          Image(R.image.placeholder.name)
            .resizable()
            .scaledToFit()
        },
        content: {
          SafeLabel("_____", icon: Image.eth)
            .padding(.top, 8)
        })
        .headerStyle(.small)
        .loading()
    }
  }
}
