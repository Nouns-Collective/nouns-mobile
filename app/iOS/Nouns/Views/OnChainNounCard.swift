//
//  OnChainNounCard.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents
import Services

/// <#Description#>
struct OnChainNounCard: View {
  
  let noun: String
  let date: String
  let owner: String
  let status: String = "Winner"
  
  var body: some View {
    StandardCard(media: {
      NounPuzzle(
        head: Image("head-baseball-gameball", bundle: Bundle.NounAssetBundle),
        body: Image("body-grayscale-9", bundle: Bundle.NounAssetBundle),
        glass: Image("glasses-square-black-rgb", bundle: Bundle.NounAssetBundle),
        accessory: Image("accessory-aardvark", bundle: Bundle.NounAssetBundle)
      )
    }, header: noun, subheader: date, detail: owner, detailSubheader: status)
  }
}

struct OnChainNounCard_Previews: PreviewProvider {
  static var previews: some View {
    OnChainNounCard(noun: "Noun 64", date: "Oct 11 2021", owner: "bobby.eth")
  }
}
