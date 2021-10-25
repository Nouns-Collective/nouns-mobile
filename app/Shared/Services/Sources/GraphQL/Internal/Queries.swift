//
//  Queries.swift
//  Services
//
//  Created by Mohammed Ibrahim on 2021-10-24.
//

import Foundation

protocol NounsGraphQLQuery: GraphQLQuery {}

extension NounsGraphQLQuery {
  var url: URL { CloudConfiguration.Nouns.query.url }
}

struct NounsSubgraph {
  struct NounsListQuery: NounsGraphQLQuery {
    var first: Int
    var skip: Int
        
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
  
  struct ProposalListQuery: NounsGraphQLQuery {
    var first: Int
    var skip: Int
        
    var query: String {
      """
        {
          proposals(skip: \(skip), first: \(first), orderBy: startBlock, orderDirection: desc) {
            startBlock
            endBlock
            description
            status
          }
        }
      """
    }
  }
}
