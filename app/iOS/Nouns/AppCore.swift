//
//  AppCore.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import Combine

// TODO: Remove after being replaced with the actual `Nouns` Service.
typealias Nouns = AnyObject
typealias Noun = Any
typealias Activity = Any

/// <#Description#>
typealias Reducer<State, Action> = (State, Action) -> State

/// <#Description#>
typealias Middleware<State, Action> = (State, Action) -> AnyPublisher<Action, Never>

/// <#Description#>
/// - Parameter service: <#service description#>
/// - Returns: <#description#>
func onChainMiddleware(service: Nouns) -> Middleware<OnChainNounsState, OnChainNounsAction> {
  fatalError("\(#function) must be implemented.")
}

/// <#Description#>
/// - Parameter service: <#service description#>
/// - Returns: <#description#>
func liveAuctionMiddleware(service: Nouns) -> Middleware<LiveAuctionState, LiveAuctionAction> {
  fatalError("\(#function) must be implemented.")
}

/// <#Description#>
/// - Parameter service: <#service description#>
/// - Returns: <#description#>
func activitiesMiddleware(service: Nouns) -> Middleware<ActivitiesState, ActivityAction> {
  fatalError("\(#function) must be implemented.")
}


/// <#Description#>
class AppCore {
  
}
