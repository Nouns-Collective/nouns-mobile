//
//  Noun.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-20.
//

import Foundation
import Apollo

public struct Noun {
  var seed: Seed
}

extension Noun: GraphResponse {
  public init?(_ apolloResponse: GraphQLSelectionSet?) {
    guard let response = apolloResponse as? NounsListQuery.Data.Noun,
          let seed = Seed(response.seed) else { return nil }
    
    self.seed = seed
  }
}
