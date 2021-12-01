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
struct SettledAuctionCard: View {
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
          .background(Color(hex: AppCore.shared.nounComposer.backgroundColors[auction.noun.seed.background]))
      },
      smallHeader: R.string.explore.noun(auction.noun.id),
      accessoryImage: Image.mdArrowCorner,
      detail: {
        SafeLabel(ethPrice, icon: Image.eth)
      })
  }
}
