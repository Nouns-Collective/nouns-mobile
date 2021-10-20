//
//  NounsListQuery.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-20.
//

import Foundation

struct NounsListGraphQuery: GraphQLQuerier {
  typealias Query = NounsListQuery
  typealias Response = NounsList
  
  func query() -> Query {
    return NounsListQuery()
  }
}
