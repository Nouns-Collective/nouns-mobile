//
//  NounsListGraphQuery.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-20.
//

import Foundation
import Apollo

struct NounsListGraphQuery {
  static let pageSize: Int = 20
  
  var skip: Int? = nil
  var pageSize: Int = NounsListGraphQuery.pageSize
}

extension NounsListGraphQuery: GraphQLQuerier {
  typealias Query = NounsListQuery
  typealias Response = NounsList
  
  func query() -> Query {
    NounsListQuery(skip: skip, first: pageSize)
  }
}
