//
//  Action.swift
//  Nouns
//
//  Created by Ziad Tamim on 09.11.21.
//

import Foundation
import Services
import Combine

/// <#Description#>
struct FetchOnChainNounsAction: Action {
  var limit = 20
  var after = 0
}

/// <#Description#>
struct FetchOnChainNounsSucceeded: Action {
  let nouns: [Noun]
}

/// <#Description#>
struct FetchOnChainNounsFailed: Action {
  let error: Error
}

/// <#Description#>
/// - Returns: <#description#>
func onChainNounsMiddleware() -> Middleware<AppState> {
 return { _, action in
   switch action {
   case let fetch as FetchOnChainNounsAction:
     return AppCore.shared.nounsService.fetchOnChainNouns(limit: fetch.limit, after: fetch.after)
       .retry(2)
       .map { FetchOnChainNounsSucceeded(nouns: $0) }
       .catch { Just(FetchOnChainNounsFailed(error: $0)) }
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
func onChainNounsReducer(state: OnChainNouns, action: Action) -> OnChainNouns {
  var state = state
  switch action {
  case is FetchOnChainNounsAction:
    state.isLoading = true
    
  case let succeeded as FetchOnChainNounsSucceeded:
    state.nouns.append(contentsOf: succeeded.nouns)
    state.isLoading = false
    
  case let failure as FetchOnChainNounsFailed:
    state.error = failure.error
    state.isLoading = false
    
  default:
    break
  }
  
  return state
}

/// <#Description#>
struct OnChainNouns {
  var nouns: [Noun] = []
  var isLoading = false
  var error: Error?
  
  var activities = OnChainNounActivities()
}
