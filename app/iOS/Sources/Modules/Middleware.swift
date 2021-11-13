//
//  Middleware.swift
//  Nouns
//
//  Created by Ziad Tamim on 07.11.21.
//

import Foundation
import Combine

typealias Middleware<State> = (State, Action) -> AnyPublisher<Action, Never>

// func activitiesMiddleware(service: Nouns) -> Middleware<ActivitiesState, ActivityAction> {
//  fatalError("\(#function) must be implemented.")
// }

// func nounActivitiesReducer(state: ActivitiesState, action: ActivityAction) -> ActivitiesState {
//  fatalError("\(#function) must be implemented.")
// }
