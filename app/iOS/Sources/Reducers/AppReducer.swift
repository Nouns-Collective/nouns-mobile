//
//  AppReducer.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import Foundation

func appReducer(state: AppState, action: Action) -> AppState {
  AppState(
    onChainAuctions: auctionReducer(state: state.onChainAuctions, action: action),
    liveAuction: liveAuctionReducer(state: state.liveAuction, action: action),
    activities: nounActivityReducer(state: state.activities, action: action),
    bids: bidReducer(state: state.bids, action: action)
  )
}
