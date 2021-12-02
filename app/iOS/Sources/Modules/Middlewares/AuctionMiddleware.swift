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
        .map { LiveAuctionDidChange(auction: $0) }
        .catch { Just(ListenLiveAuctionFailed(error: $0)) }
        .eraseToAnyPublisher()
    
    case let listen as ListenLiveAuctionRemainingTimeChangesAction:
      return Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
        .compactMap { _ in
          guard let endDateTimeInterval = Double(listen.auction.endTime) else {
            return nil
          }
          
          let now = Date()
          let end = Date(timeIntervalSince1970: endDateTimeInterval)
          let components = Calendar.current.dateComponents([.hour, .minute, .second], from: now, to: end)
          
          return LiveAuctionRemainingTimeDidChange(remainingTime: components)
        }
        .eraseToAnyPublisher()
      
    default:
      return Empty().eraseToAnyPublisher()
    }
  }
}
