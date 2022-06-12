// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import Foundation

internal enum NounsSubgraph {
  
  internal struct NounQuery: GraphQLQuery {
    internal let url = CloudConfiguration.Nouns.query.url
    internal let id: String
    
    internal var operationDefinition: String {
      """
      {
        nouns(where: {id: "\(id)"}) {
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
              quorumVotes
              votes {
                id
                support
                votes
              }
              executionETA
            }
          }
        }
      }
      """
    }
  }
  
  internal struct AuctionsQuery: GraphQLPaginatingQuery {
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
            quorumVotes
            votes {
              id
              support
              votes
            }
            executionETA
            createdTimestamp
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
