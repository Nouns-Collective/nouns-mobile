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
  
  let auction: Auction
  
  private var ethPrice: String {
    let formatter = EtherFormatter(from: .wei)
    formatter.unit = .eth
    return formatter.string(from: auction.amount) ?? R.string.shared.notApplicable()
  }
  
  var body: some View {
    StandardCard(
      media: {
        NounPuzzle(
          head: Image(nounTraitName: AppCore.shared.nounComposer.heads[auction.noun.seed.head].assetImage),
          body: Image(nounTraitName: AppCore.shared.nounComposer.bodies[auction.noun.seed.body].assetImage),
          glass: Image(nounTraitName: AppCore.shared.nounComposer.glasses[auction.noun.seed.glasses].assetImage),
          accessory: Image(nounTraitName: AppCore.shared.nounComposer.accessories[auction.noun.seed.accessory].assetImage))
          .matchedGeometryEffect(id: "\(auction.noun.id)-puzzle", in: animation)
          .background(Color(hex: AppCore.shared.nounComposer.backgroundColors[auction.noun.seed.background]))
      },
      smallHeader: R.string.explore.noun(auction.noun.id),
      accessoryImage: Image.mdArrowCorner,
      detail: {
        SafeLabel(ethPrice, icon: Image.eth)
      })
  }
}

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
