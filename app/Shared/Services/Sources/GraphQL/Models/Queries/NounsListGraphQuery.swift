//
//  NounsListGraphQuery.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-20.
//

import Foundation
import Apollo

public struct NounsListGraphQuery {
  public static let pageSize: Int = 20
  
  var skip: Int? = nil
  var pageSize: Int = NounsListGraphQuery.pageSize
  
  public init(skip: Int? = nil, pageSize: Int = NounsListGraphQuery.pageSize) {
    
  }
}

extension NounsListGraphQuery: GraphQLQuerier {
  public typealias Query = NounsListQuery
  public typealias Response = NounsList
  
  public func query() -> Query {
    NounsListQuery(skip: skip, first: pageSize)
  }
}
