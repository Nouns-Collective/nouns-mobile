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
          head: Image(nounTraitName: AppCore.shared.nounComposer.heads[noun.seed.head].assetImage),
          body: Image(nounTraitName: AppCore.shared.nounComposer.bodies[noun.seed.body].assetImage),
          glass: Image(nounTraitName: AppCore.shared.nounComposer.glasses[noun.seed.glasses].assetImage),
          accessory: Image(nounTraitName: AppCore.shared.nounComposer.accessories[noun.seed.accessory].assetImage)
        )
          .matchedGeometryEffect(id: "\(noun)-puzzle", in: animation)
      },
      smallHeader: "Noun \(noun.id)",
      accessoryImage: Image.mdArrowCorner,
      detail: {
        SafeLabel("89.00", icon: Image.eth)
      })
  }
}
