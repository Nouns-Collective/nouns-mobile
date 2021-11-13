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
  
  let noun: String
  
  var body: some View {
    StandardCard(
      media: {
        NounPuzzle(
          head: Image("head-baseball-gameball", bundle: Bundle.NounAssetBundle),
          body: Image("body-grayscale-9", bundle: Bundle.NounAssetBundle),
          glass: Image("glasses-square-black-rgb", bundle: Bundle.NounAssetBundle),
          accessory: Image("accessory-aardvark", bundle: Bundle.NounAssetBundle)
        )
      },
      header: noun,
      accessoryImage: Image.mdArrowCorner,
      leftDetail: {
        CardDetailView(
          header: "4h 17m 23s",
          headerIcon: Image.timeleft,
          subheader: "Remaining")
      },
      rightDetail: {
        CardDetailView(
          header: "89.00",
          headerIcon: Image(systemName: "dollarsign.circle"),
          subheader: "Current bid")
      })
  }
}

struct LiveAuctionCardPreview: PreviewProvider {
  static var previews: some View {
    LiveAuctionCard(noun: "Noun 64")
      .previewLayout(.sizeThatFits)
  }
}
