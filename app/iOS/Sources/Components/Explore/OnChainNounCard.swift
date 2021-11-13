//
//  OnChainNounCard.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents

/// Card showing a noun along with the date it was created, the owner of the noun, and a status label.
struct OnChainNounCard: View {
  var animation: Namespace.ID
  
  let noun: String
  let date: String
  let owner: String
  let status: String = "Winner"
  
  var body: some View {
    StandardCard(
      media: {
        NounPuzzle(
          head: Image("head-baseball-gameball", bundle: Bundle.NounAssetBundle),
          body: Image("body-grayscale-9", bundle: Bundle.NounAssetBundle),
          glass: Image("glasses-square-black-rgb", bundle: Bundle.NounAssetBundle),
          accessory: Image("accessory-aardvark", bundle: Bundle.NounAssetBundle))
          .matchedGeometryEffect(id: "\(noun)-puzzle", in: animation)
      },
      smallHeader: noun,
      accessoryImage: Image.mdArrowCorner,
      detail: {
        CardDetailView(
          header: "89.00",
          headerIcon: Image.eth,
          subheader: nil)
      })
  }
}
