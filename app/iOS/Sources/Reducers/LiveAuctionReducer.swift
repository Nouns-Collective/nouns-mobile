//
//  LiveAuctionReducer.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import Foundation

func liveAuctionReducer(state: LiveAuction, action: Action) -> LiveAuction {
  var state = state
  switch action {
  case is ListenLiveAuctionAction:
    state.isLoading = true
    
  case let sink as SinkLiveAuctionAction:
    state.auction = sink.auction
    state.isLoading = false
    
  case let failure as ListenLiveAuctionFailed:
    state.error = failure.error
    state.isLoading = false
    print("Error: \(failure.error)")
    
  default:
    break
  }
  return state
}
