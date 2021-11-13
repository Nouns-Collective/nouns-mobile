//
//  Nouns+Queries.swift
//  
//
//  Created by Ziad Tamim on 12.11.21.
//

import Foundation

internal enum NounsSubgraph {
    
    internal struct NounsQuery: GraphQLQuery {
        internal let url: URL = CloudConfiguration.Nouns.query.url
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
        internal var url: URL = CloudConfiguration.Nouns.query.url
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
    
    internal struct ProposalsQuery: GraphQLQuery {
        internal var url: URL = CloudConfiguration.Nouns.query.url
        internal let first: Int
        internal let skip: Int
        
        internal var operationDefinition: String {
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

