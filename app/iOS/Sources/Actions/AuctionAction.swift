//
//  AuctionAction.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import Foundation
import Services

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
