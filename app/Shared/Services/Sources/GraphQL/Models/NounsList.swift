//
//  NounsList.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-20.
//

import Foundation
import Apollo

public struct NounsList {
  var nouns: [Noun]
}

extension NounsList: GraphResponse {
  public init?(_ apolloResponse: GraphQLSelectionSet) {
    guard let response = apolloResponse as? NounsListQuery.Data else { return nil }
    self.nouns = response.nouns.compactMap { Noun($0) }
  }
}
