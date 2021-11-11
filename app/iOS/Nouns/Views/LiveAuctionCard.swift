//
//  LiveAuctionCard.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents
import Services

/// <#Description#>
/// - Parameters:
///   - state: <#state description#>
///   - action: <#action description#>
/// - Returns: <#description#>
func liveAuctionReducer(state: LiveAuctionState, action: LiveAuctionAction) -> LiveAuctionState {
  fatalError("\(#function) must be implemented.")
}

/// <#Description#>
struct LiveAuctionState {
  var auction: Auction
}

/// <#Description#>
enum LiveAuctionAction {
  case listen
  case sink(Auction)
  case failure(Error)
}

/// <#Description#>
struct LiveAuctionCard: View {
  
  let noun: String
  
  var body: some View {
    StandardCard(media: {
      NounPuzzle(
        head: Image("head-baseball-gameball", bundle: Bundle.NounAssetBundle),
        body: Image("body-grayscale-9", bundle: Bundle.NounAssetBundle),
        glass: Image("glasses-square-black-rgb", bundle: Bundle.NounAssetBundle),
        accessory: Image("accessory-aardvark", bundle: Bundle.NounAssetBundle)
      )
    }, header: noun, accessoryImage: Image(systemName: "arrow.up.right"), leftDetail: {
        CardDetailView(header: "4h 17m 23s", headerIcon: nil, subheader: "Remaining")
    }, rightDetail: {
        CardDetailView(header: "89.00", headerIcon: Image(systemName: "dollarsign.circle"), subheader: "Current bid")
    })
  }
}

struct LiveAuctionCardPreview: PreviewProvider {
  static var previews: some View {
    LiveAuctionCard(noun: "Noun 64")
  }
}
