//
//  OnChainNounBids.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-20.
//

import Foundation
import Combine
import Services

/// <#Description#>
struct FetchOnChainNounBidsAction: Action {
  let noun: Noun
}

/// <#Description#>
struct FetchOnChainNounBidsSucceeded: Action {
  let bids: [Bid]
}

/// <#Description#>
struct FetchOnChainNounBidsFailed: Action {
  let error: Error
}

/// <#Description#>
/// - Returns: <#description#>
func onChainNounBidsMiddleware() -> Middleware<AppState> {
 return { _, action in
   switch action {
   case let fetch as FetchOnChainNounBidsAction:
     return AppCore.shared.nounsService.fetchBids(for: fetch.noun.id)
       .map { FetchOnChainNounBidsSucceeded(bids: $0) }
       .catch { Just(FetchOnChainNounBidsFailed(error: $0)) }
       .eraseToAnyPublisher()
     
   default:
     return Empty().eraseToAnyPublisher()
   }
 }
}

/// <#Description#>
/// - Parameters:
///   - state: <#state description#>
///   - action: <#action description#>
/// - Returns: <#description#>
func onChainNounBidsReducer(state: OnChainNounBids, action: Action) -> OnChainNounBids {
  var state = state
  switch action {
  case is FetchOnChainNounBidsAction:
    state.isLoading = true
    
  case let succeeded as FetchOnChainNounBidsSucceeded:
    state.bids = succeeded.bids
    state.isLoading = false
    
  case let failure as FetchOnChainNounBidsFailed:
    state.error = failure.error
    state.isLoading = false
    
  default:
    break
  }
  return state
}

/// <#Description#>
struct OnChainNounBids {
  var bids: [Bid] = []
  var isLoading = false
  var error: Error?
}
