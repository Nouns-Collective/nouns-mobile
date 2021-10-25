//
//  Queries.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-24.
//

import Foundation

struct NounsSubgraph {
  struct NounsListQuery: GraphQLQuery {
    var first: Int
    var skip: Int
    
    var url: URL = CloudConfiguration.Nouns.query.url
    
    var query: String {
      """
          {
            nouns(first: \(first), skip: \(skip)) {
              id
              seed {
                background
                body
                accessory
                head
                glasses
              }
              owner {
                id
              }
            }
          }
      """
    }
  }
}
