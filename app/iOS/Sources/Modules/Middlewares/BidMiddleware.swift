//
//  BidMiddleware.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import Foundation
import Combine

func bidMiddleware() -> Middleware<AppState> {
 return { _, action in
   switch action {
   case let fetch as FetchBidHistoryAction:
     return AppCore.shared.nounsService.fetchBids(for: fetch.noun.id)
       .map { FetchBidHistorySucceeded(bids: $0) }
       .catch { Just(FetchBidHistoryFailed(error: $0)) }
       .eraseToAnyPublisher()
     
   default:
     return Empty().eraseToAnyPublisher()
   }
 }
}
