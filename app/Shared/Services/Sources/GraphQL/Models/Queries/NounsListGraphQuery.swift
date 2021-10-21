//
//  NounsListGraphQuery.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-20.
//

import Foundation
import Apollo

struct NounsListGraphQuery {
  // TODO: - Add properties for pagination
}

extension NounsListGraphQuery: GraphQLQuerier {
  typealias Query = NounsListQuery
  typealias Response = NounsList
  
  func query() -> Query {
    NounsListQuery()
  }
}
