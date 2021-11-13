//
//  Subscriptions.swift
//  
//
//  Created by Ziad Tamim on 12.11.21.
//

import Foundation

extension NounsSubgraph {
    
    internal struct LiveAuctionSubscription: GraphQLSubscription {
        internal var url: URL { CloudConfiguration.Nouns.subscription.url }
        
        internal var operationDefinition: String {
          """
          {
            auctions(orderDirection: desc, first: 1, orderBy: startTime) {
              id
              amount
              startTime
              endTime
              bids(orderDirection: desc, first: 10) {
                id
                amount
                noun {
                  id
                }
              }
            }
          }
          """
        }
    }
}
