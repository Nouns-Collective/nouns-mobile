//
//  AuctionReducer.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import Foundation
import Services

func auctionReducer(state: AuctionState, action: Action) -> AuctionState {
  AuctionState(
    settledAuctions: settledAuctionsReducer(state: state.settledAuctions, action: action),
    liveAuction: liveAuctionReducer(state: state.liveAuction, action: action)
  )
}
  
/// Handles all `Settled Auctions` actions.
func settledAuctionsReducer(state: SettledAuctionsState, action: Action) -> SettledAuctionsState {
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
func liveAuctionReducer(state: LiveAuctionState, action: Action) -> LiveAuctionState {
  var state = state
  switch action {
  case is ListenLiveAuctionAction:
    state.isLoading = true
    
  case let output as LiveAuctionDidChange:
    state.auction = output.auction
    state.isLoading = false
    
  case let failure as ListenLiveAuctionFailed:
    state.error = failure.error
    state.isLoading = false
  
  case let output as LiveAuctionRemainingTimeDidChange:
    state.remainingTime = output.remainingTime
    
  default:
    break
  }
  
  return state
}
