//
//  ActivityMiddleware.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import Foundation
import Combine
import Services

func activityMiddleware() -> Middleware<AppState> {
 return { _, action in
   switch action {
   case let fetch as FetchNounActivityAction:
     return AppCore.shared.nounsService.fetchActivity(for: fetch.noun.id)
       .map { FetchNounActivitySucceeded(votes: $0) }
       .catch { Just(FetchNounActivityFailed(error: $0)) }
       .eraseToAnyPublisher()
     
   default:
     return Empty().eraseToAnyPublisher()
   }
 }
}
