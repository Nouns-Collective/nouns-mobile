//
//  ActivityAction.swift
//  Nouns
//
//  Created by Ziad Tamim on 01.12.21.
//

import Foundation
import Services

struct FetchNounActivityAction: Action {
  let noun: Noun
}

struct FetchNounActivitySucceeded: Action {
  let votes: [Vote]
}

struct FetchNounActivityFailed: Action {
  let error: Error
}
