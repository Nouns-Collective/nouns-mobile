//
//  OnChainAuctions.swift
//  Auctions
//
//  Created by Mohammed Ibrahim on 2021-11-19.
//

import Foundation
import Services

struct AuctionState {
  var auctions: [Auction] = []
  var isLoading = false
  var error: Error?
}
