//
//  LiveAuctionCard.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents
import Services

struct LiveAuctionCard: View {
  let auction: Auction
  
  var body: some View {
    StandardCard(
      media: {
        NounPuzzle(
          head: Image(nounTraitName: AppCore.shared.nounComposer.heads[auction.noun.seed.head].assetImage),
          body: Image(nounTraitName: AppCore.shared.nounComposer.bodies[auction.noun.seed.body].assetImage),
          glass: Image(nounTraitName: AppCore.shared.nounComposer.glasses[auction.noun.seed.glasses].assetImage),
          accessory: Image(nounTraitName: AppCore.shared.nounComposer.accessories[auction.noun.seed.accessory].assetImage)
        )
      },
      header: "Noun \(auction.noun.id)",
      accessoryImage: Image.mdArrowCorner,
      leftDetail: {
        CompoundLabel(Text("9h 17m 23s"), icon: Image.timeleft, caption: "Remaining")
      },
      rightDetail: {
        CompoundLabel(SafeLabel("89.00", icon: Image.eth), icon: Image.currentBid, caption: "Current bid")
      })
  }
}
