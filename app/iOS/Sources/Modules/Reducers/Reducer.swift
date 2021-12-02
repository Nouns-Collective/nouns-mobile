//
//  Reducer.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import Foundation

typealias Reducer<State> = (State, Action) -> State
