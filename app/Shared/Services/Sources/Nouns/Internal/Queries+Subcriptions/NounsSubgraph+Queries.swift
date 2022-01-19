//
//  Nouns+Queries.swift
//  
//
//  Created by Ziad Tamim on 12.11.21.
//

import Foundation

internal enum NounsSubgraph {
  
  internal struct NounsQuery: GraphQLPaginatingQuery {
    internal let url = CloudConfiguration.Nouns.query.url
    internal var limit: Int
    internal var skip: Int
    
    internal var operationDefinition: String {
      """
      {
        nouns(first: \(limit), skip: \(skip)) {
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
  
  internal struct ActivitiesQuery: GraphQLPaginatingQuery {
    internal var url = CloudConfiguration.Nouns.query.url
    internal let nounID: String
    internal var limit: Int
    internal var skip: Int
    
    internal var operationDefinition: String {
      """
      {
        noun(id: \(nounID)) {
          votes(first: \(limit), skip: \(skip)) {
            id
            supportDetailed
            proposal {
              id
              description
              status
            }
          }
        }
      }
      """
    }
  }
  
  internal struct AutionsQuery: GraphQLPaginatingQuery {
    internal var url = CloudConfiguration.Nouns.query.url
    internal let settled: Bool
    internal var limit: Int
    internal var skip: Int
    
    var operationDefinition: String {
      """
      {
        auctions(first: \(limit), skip: \(skip), orderBy: startTime, orderDirection: desc, where: { settled: \(settled) }) {
          id
          amount
          startTime
          endTime
          settled
          noun {
            id
            owner {
              id
            }
            seed {
              background
              head
              glasses
              accessory
              body
            }
          }
          bidder {
            id
          }
        }
      }
      """
    }
  }
  
  internal struct ProposalsQuery: GraphQLPaginatingQuery {
    internal var url = CloudConfiguration.Nouns.query.url
    internal var limit: Int
    internal var skip: Int
    
    internal var operationDefinition: String {
      """
        {
          proposals(skip: \(skip), first: \(limit), orderBy: startBlock, orderDirection: desc) {
            id
            description
            status
          }
        }
      """
    }
  }
  
  internal struct BidsQuery: GraphQLPaginatingQuery {
    internal var url = CloudConfiguration.Nouns.query.url
    internal let nounID: String
    internal var limit: Int
    internal var skip: Int
    
    internal var operationDefinition: String {
      """
        {
          bids(skip: \(skip), first: \(limit), orderBy: blockTimestamp, orderDirection: desc, where: { noun: "\(nounID)" }) {
            id
            amount
            blockTimestamp
            bidder {
              id
            }
          }
        }
      """
    }
  }
}
