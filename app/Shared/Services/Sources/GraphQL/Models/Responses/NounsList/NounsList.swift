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
  
  mutating func append(_ nouns: [Noun]) {
    self.nouns.append(contentsOf: nouns)
  }
}

extension NounsList: GraphResponse {
  public init?(_ response: GraphQLSelectionSet?) {
    guard let response = response as? NounsListQuery.Data else { return nil }
    self.nouns = response.nouns.compactMap { Noun($0) }
  }
}

extension NounsList: Paginating {
  typealias Query = NounsListGraphQuery

  var skip: Int { nouns.count }
  
  func nextPage() -> Query {
    return NounsListGraphQuery(skip: skip, pageSize: NounsListGraphQuery.pageSize)
  }
}
