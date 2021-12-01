//
//  AppState.swift
//  Nouns
//
//  Created by Ziad Tamim on 10.11.21.
//

import Foundation

struct AppState {
  var onChainAuctions = AuctionState()
  var liveAuction = LiveAuction()
  var activities = ActivityState()
  var bids = BidState()
}
