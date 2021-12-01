//
//  ListenLiveAuctionAction.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import Foundation
import Services

struct ListenLiveAuctionAction: Action { }

struct SinkLiveAuctionAction: Action {
  let auction: Auction
}

struct ListenLiveAuctionFailed: Action {
  let error: Error
}
