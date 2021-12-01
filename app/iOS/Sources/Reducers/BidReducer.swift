//
//  BidReducer.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import Foundation

func bidReducer(state: BidState, action: Action) -> BidState {
  var state = state
  switch action {
  case is FetchBidHistoryAction:
    state.isLoading = true
    
  case let succeeded as FetchBidHistorySucceeded:
    state.bids = succeeded.bids
    state.isLoading = false
    
  case let failure as FetchBidHistoryFailed:
    state.error = failure.error
    state.isLoading = false
    
  default:
    break
  }
  return state
}
