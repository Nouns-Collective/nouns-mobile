//
//  OnChainNounCard.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents
import Services

/// Card showing a noun along with the date it was created, the owner of the noun, and a status label.
struct OnChainNounCard: View {
  var animation: Namespace.ID
  
  let noun: Noun
  
  var body: some View {
    StandardCard(
      media: {
        NounPuzzle(
          head: AppCore.shared.nounComposer.heads[noun.seed.head].data,
          body: AppCore.shared.nounComposer.bodies[noun.seed.body].data,
          glass: AppCore.shared.nounComposer.glasses[noun.seed.glasses].data,
          accessory: AppCore.shared.nounComposer.accessories[noun.seed.accessory].data)
          .matchedGeometryEffect(id: "\(noun)-puzzle", in: animation)
      },
      smallHeader: "Noun \(noun.id)",
      accessoryImage: Image.mdArrowCorner,
      detail: {
        CardDetailView(
          header: "89.00",
          headerIcon: Image.eth,
          subheader: nil)
      })
  }
}
