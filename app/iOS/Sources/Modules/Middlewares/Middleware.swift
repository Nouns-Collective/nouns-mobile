//
//  Middleware.swift
//  Nouns
//
//  Created by Ziad Tamim on 07.11.21.
//

import Foundation
import Combine

typealias Middleware<State> = (State, Action) -> AnyPublisher<Action, Never>
