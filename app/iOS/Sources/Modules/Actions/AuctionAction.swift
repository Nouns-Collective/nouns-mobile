//
//  AuctionAction.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import Foundation
import Services

/// Settled Auctions
struct FetchAuctionsAction: Action {
  var limit = 20
  var after = 0
}

struct FetchAuctionsSucceeded: Action {
  let auctions: [Auction]
}

struct FetchOnChainAuctionsFailed: Action {
  let error: Error
}

/// Live Auction Actions
struct ListenLiveAuctionAction: Action { }

struct LiveAuctionDidChange: Action {
  let auction: Auction
}

struct ListenLiveAuctionFailed: Action {
  let error: Error
}

struct ListenLiveAuctionRemainingTimeChangesAction: Action {
  let auction: Auction
}

struct LiveAuctionRemainingTimeDidChange: Action {
  let remainingTime: DateComponents
}
