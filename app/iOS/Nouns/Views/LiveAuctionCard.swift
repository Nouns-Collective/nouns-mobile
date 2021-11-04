//
//  LiveAuctionCard.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI

// TODO: Should be removed after service importation
typealias Auction = Any

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
  
  var body: some View {
    Text("Live Auction.")
  }
}
