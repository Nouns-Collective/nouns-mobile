//
//  OnChainNounBids.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-20.
//

import Foundation
import Services

struct BidState {
  var bids: [Bid] = []
  var isLoading = false
  var error: Error?
}
