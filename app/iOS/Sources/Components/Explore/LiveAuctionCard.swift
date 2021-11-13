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
          head: AppCore.shared.nounComposer.heads[auction.noun.seed.head].data,
          body: AppCore.shared.nounComposer.bodies[auction.noun.seed.body].data,
          glass: AppCore.shared.nounComposer.glasses[auction.noun.seed.glasses].data,
          accessory: AppCore.shared.nounComposer.accessories[auction.noun.seed.accessory].data)
      },
      header: "Noun \(auction.noun.id)",
      accessoryImage: Image.mdArrowCorner,
      leftDetail: {
          CardDetailView(
            header: "9h 17m 23s",
            headerIcon: nil,
            subheader: "Remaining")
      },
      rightDetail: {
        CardDetailView(
          header: "2.0",
          headerIcon: Image(systemName: "dollarsign.circle"),
          subheader: "Current bid")
      })
  }
}
