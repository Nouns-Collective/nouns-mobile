//
//  AppReducer.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import Foundation

func appReducer(state: AppState, action: Action) -> AppState {
  AppState(
    auction: auctionReducer(state: state.auction, action: action),
    activity: nounActivityReducer(state: state.activity, action: action),
    bid: bidReducer(state: state.bid, action: action)
  )
}
