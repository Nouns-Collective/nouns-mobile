//
//  OnChainAuctions.swift
//  Auctions
//
//  Created by Mohammed Ibrahim on 2021-11-19.
//

import Foundation
import Services

struct AuctionState {
  var settledAuctions = SettledAuctionsState()
  var liveAuction = LiveAuctionState()
}

struct LiveAuctionState {
  var auction: Auction?
  var isLoading = false
  var error: Error?
  var remainingTime: DateComponents?
}

struct SettledAuctionsState {
  var auctions: [Auction] = []
  var isLoading = false
  var error: Error?
}
