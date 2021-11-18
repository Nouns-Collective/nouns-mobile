//
//  NounActivities.swift
//  Nouns
//
//  Created by Ziad Tamim on 13.11.21.
//

import Foundation
import Combine
import Services
import SwiftUI

/// <#Description#>
struct FetchOnChainNounActivitiesAction: Action {
  let noun: Noun
}

/// <#Description#>
struct FetchOnChainNounActivitiesSucceeded: Action {
  let votes: [Vote]
}

/// <#Description#>
struct FetchOnChainNounActivitiesFailed: Action {
  let error: Error
}

/// <#Description#>
/// - Returns: <#description#>
func onChainNounActivitiesMiddleware() -> Middleware<AppState> {
 return { _, action in
   switch action {
   case let fetch as FetchOnChainNounActivitiesAction:
     return AppCore.shared.nounsService.fetchActivity(for: fetch.noun.id)
       .map { FetchOnChainNounActivitiesSucceeded(votes: $0) }
       .catch { Just(FetchOnChainNounActivitiesFailed(error: $0)) }
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
func onChainNounActivitiesReducer(state: OnChainNounActivities, action: Action) -> OnChainNounActivities {
  var state = state
  switch action {
  case is FetchOnChainNounActivitiesAction:
    state.isLoading = true
    
  case let succeeded as FetchOnChainNounActivitiesSucceeded:
    state.votes = succeeded.votes
    state.isLoading = false
    
  case let failure as FetchOnChainNounActivitiesFailed:
    state.error = failure.error
    state.isLoading = false
    
  default:
    break
  }
  return state
}

/// <#Description#>
struct OnChainNounActivities {
  var votes: [Vote] = []
  var isLoading = false
  var error: Error?
}
