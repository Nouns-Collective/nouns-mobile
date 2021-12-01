//
//  AuctionMiddleware.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import Foundation
import Services
import Combine

func auctionsMiddleware() -> Middleware<AppState> {
  return { _, action in
    switch action {
    case let fetch as FetchAuctionsAction:
      return AppCore.shared.nounsService.fetchAuctions(settled: true, limit: fetch.limit, cursor: fetch.after)
        .retry(2)
        .map { FetchAuctionsSucceeded(auctions: $0) }
        .catch { Just(FetchOnChainAuctionsFailed(error: $0)) }
        .eraseToAnyPublisher()
     
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
