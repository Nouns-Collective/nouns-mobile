//
//  ActivityReducer.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import Foundation

func nounActivityReducer(state: ActivityState, action: Action) -> ActivityState {
  var state = state
  switch action {
  case is FetchNounActivityAction:
    state.isLoading = true
    
  case let succeeded as FetchNounActivitySucceeded:
    state.votes = succeeded.votes
    state.isLoading = false
    
  case let failure as FetchNounActivityFailed:
    state.error = failure.error
    state.isLoading = false
    
  default:
    break
  }
  return state
}
