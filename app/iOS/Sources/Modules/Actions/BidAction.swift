//
//  BidAction.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import Foundation
import Services

struct FetchBidHistoryAction: Action {
  let auction: Auction
}

struct FetchBidHistorySucceeded: Action {
  let bids: [Bid]
}

struct FetchBidHistoryFailed: Action {
  let error: Error
}
