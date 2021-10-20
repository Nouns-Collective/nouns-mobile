//
//  Noun+GraphResponse.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-20.
//

import Foundation
import Apollo

extension Noun: GraphResponse {
  public init?(_ apolloResponse: GraphQLSelectionSet?) {
    guard let response = apolloResponse as? NounsListQuery.Data.Noun,
          let seed = Seed(response.seed) else { return nil }
    
    self.seed = seed
  }
}
