//
//  GraphQLOperation.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-24.
//

import Foundation

struct GraphQLOperation: Encodable {
  var url: URL
  var query: String
  
  public init(url: URL, query: String) {
    self.url = url
    self.query = query
  }
  
  private enum CodingKeys: String, CodingKey {
    case query
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(query, forKey: .query)
  }
}

extension GraphQLOperation {
  init(query: GraphQLQuery) {
    self.url = query.url
    self.query = query.query
  }
}
