//
//  AuctionReducer.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import Foundation
import Services

func auctionReducer(state: AuctionState, action: Action) -> AuctionState {
  var state = settledAuctionsReducer(state: state, action: action)
  state = liveAuctionReducer(state: state, action: action)
  return state
}
  
/// Handles all `Settled Auctions` actions.
func settledAuctionsReducer(state: AuctionState, action: Action) -> AuctionState {
  var state = state
  switch action {
  case is FetchAuctionsAction:
    state.isLoading = true
    
  case let succeeded as FetchAuctionsSucceeded:
    state.auctions.append(contentsOf: succeeded.auctions)
    state.isLoading = false
    
  case let failure as FetchOnChainAuctionsFailed:
    state.error = failure.error
    state.isLoading = false
    
  default:
    break
  }
  
  return state
}

/// Handles all `Live Auction` actions
func liveAuctionReducer(state: AuctionState, action: Action) -> AuctionState {
  var state = state
  switch action {
  case is ListenLiveAuctionAction:
    state.isLoading = true
    
  case let sink as SinkLiveAuctionAction:
    state.liveAuction = sink.auction
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
