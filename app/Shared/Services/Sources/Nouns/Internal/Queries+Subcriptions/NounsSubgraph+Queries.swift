//
//  Nouns+Queries.swift
//  
//
//  Created by Ziad Tamim on 12.11.21.
//

import Foundation

internal enum NounsSubgraph {
    
    internal struct NounsQuery: GraphQLQuery {
        internal let url = CloudConfiguration.Nouns.query.url
        internal let first: Int
        internal let skip: Int
        
        internal var operationDefinition: String {
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
    
    internal struct ActivitiesQuery: GraphQLQuery {
        internal var url = CloudConfiguration.Nouns.query.url
        internal let nounID: String
        
        internal var operationDefinition: String {
          """
          {
            noun(id: \(nounID)) {
              votes {
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
    
    internal struct AutionsQuery: GraphQLQuery {
        internal var url = CloudConfiguration.Nouns.query.url
        internal let settled: Bool
        internal let first: Int
        internal let skip: Int
        
        var operationDefinition: String {
        """
          {
            auctions(first: \(first), skip: \(skip), orderBy: startTime, where: { settled: \(settled) }) {
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
            }
          }
          """
        }
    }
    
    internal struct ProposalsQuery: GraphQLQuery {
        internal var url = CloudConfiguration.Nouns.query.url
        internal let first: Int
        internal let skip: Int
        
        internal var operationDefinition: String {
          """
            {
              proposals(skip: \(skip), first: \(first), orderBy: startBlock, orderDirection: desc) {
                id
                description
                status
              }
            }
          """
        }
    }
    
    internal struct BidsQuery: GraphQLQuery {
        internal var url = CloudConfiguration.Nouns.query.url
        internal let first: Int
        internal let skip: Int
        internal let auctionID: String
        
        internal var operationDefinition: String {
          """
            {
              bids(first: 10, orderBy: blockTimestamp, orderDirection: desc, where: { auction: "\(auctionID)" }) {
                id
                amount
                blockTimestamp
                account {
                  id
                }
              }
            }
          """
        }
    }
}
