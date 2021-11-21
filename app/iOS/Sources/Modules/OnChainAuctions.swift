//
//  OnChainAuctions.swift
//  Auctions
//
//  Created by Mohammed Ibrahim on 2021-11-19.
//

import Foundation
import Services
import Combine

struct FetchOnChainAuctionsAction: Action {
  var limit = 20
  var after = 0
}

struct FetchOnChainAuctionsSucceeded: Action {
  let auctions: [Auction]
}

struct FetchOnChainAuctionsFailed: Action {
  let error: Error
}

func onChainAuctionsMiddleware() -> Middleware<AppState> {
 return { _, action in
   switch action {
   case let fetch as FetchOnChainAuctionsAction:
     return AppCore.shared.nounsService.fetchAuctions(settled: true, limit: fetch.limit, cursor: fetch.after)
       .retry(2)
       .map { FetchOnChainAuctionsSucceeded(auctions: $0) }
       .catch { Just(FetchOnChainAuctionsFailed(error: $0)) }
       .eraseToAnyPublisher()
     
   default:
     return Empty().eraseToAnyPublisher()
   }
 }
}

func onChainAuctionsReducer(state: OnChainAuctions, action: Action) -> OnChainAuctions {
  var state = state
  switch action {
  case is FetchOnChainAuctionsAction:
    state.isLoading = true
    
  case let succeeded as FetchOnChainAuctionsSucceeded:
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

struct OnChainAuctions {
  var auctions: [Auction] = []
  var isLoading = false
  var error: Error?
}
