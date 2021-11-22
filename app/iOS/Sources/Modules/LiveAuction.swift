//
//  OnChain.swift
//  Nouns
//
//  Created by Ziad Tamim on 09.11.21.
//

import Foundation
import Combine
import Services

struct ListenLiveAuctionAction: Action { }

struct SinkLiveAuctionAction: Action {
  let auction: Auction
}

struct ListenLiveAuctionFailed: Action {
  let error: Error
}

func liveAuctionMiddleware() -> Middleware<AppState> {
  return { _, action in
    switch action {
    case is ListenLiveAuctionAction:
      return AppCore.shared.nounsService.liveAuctionStateDidChange()
        .retry(2)
        .map { SinkLiveAuctionAction(auction: $0) }
        .catch { Just(ListenLiveAuctionFailed(error: $0)) }
        .eraseToAnyPublisher()
      
    default:
      return Empty().eraseToAnyPublisher()
    }
  }
}

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

struct LiveAuction {
  var auction: Auction?
  var isLoading = false
  var error: Error?
}
