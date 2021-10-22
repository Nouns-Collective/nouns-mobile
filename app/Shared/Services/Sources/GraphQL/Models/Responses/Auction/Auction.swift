//
//  Auction.swift
//  ServicesTests
//
//  Created by Mohammed Ibrahim on 2021-10-22.
//

import Foundation
import Apollo

struct Auction {
  var id: String
  var amount: String
  var startTime: String
  var endTime: String
  var settled: Bool
}

extension Auction: GraphResponse {
  init?(_ response: GraphQLSelectionSet?) {
    guard let response = response as? AuctionSubscription.Data.Auction else { return nil }
    self.id = response.id
    self.amount = response.amount
    self.startTime = response.startTime
    self.endTime = response.endTime
    self.settled = response.settled
  }
}
