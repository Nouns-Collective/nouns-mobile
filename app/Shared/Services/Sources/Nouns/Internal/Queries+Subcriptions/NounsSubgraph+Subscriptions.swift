//
//  Subscriptions.swift
//  
//
//  Created by Ziad Tamim on 12.11.21.
//

import Foundation

extension NounsSubgraph {
    
    internal struct LiveAuctionSubscription: GraphQLQuery {
        internal let url: URL = CloudConfiguration.Nouns.query.url
        
        internal var operationDefinition: String {
          """
          {
            auctions( where: {settled: false}) {
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
              
              bids(orderDirection: desc, first: 10) {
                id
                amount
                blockTimestamp
                bidder {
                    id
                }
              }
            }
          }
          """
        }
    }
}
