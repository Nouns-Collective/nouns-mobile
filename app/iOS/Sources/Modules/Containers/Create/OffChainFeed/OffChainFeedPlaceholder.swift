//
//  OffChainFeedPlaceholder.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-12-26.
//

import SwiftUI
import UIComponents

struct OffChainFeedPlaceholder: View {
  let action: () -> Void
  @Environment(\.nounComposer) private var nounComposer

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(R.string.create.subhealine())
        .font(.custom(.regular, size: 17))
      
      Spacer()

      // TODO: OffChainNoun && OnchainNoun conform to Noun
      // TODO: Integrate the NounCreator to randomly generate Traits each time the view appear.
      NounPuzzle(
        head: nounComposer.heads[3].assetImage,
        body: nounComposer.bodies[6].assetImage,
        glasses: nounComposer.glasses[0].assetImage,
        accessory: nounComposer.accessories[0].assetImage)

      OutlineButton(
        text: R.string.create.proceedTitle(),
        largeAccessory: { Image.fingergunsRight },
        action: action)
        .controlSize(.large)

      Spacer()
    }
  }
}
