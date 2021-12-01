//
//  AuctionReducer.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import Foundation
import Services

func auctionReducer(state: AuctionState, action: Action) -> AuctionState {
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
