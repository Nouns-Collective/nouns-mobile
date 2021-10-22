//
//  AuctionsList.swift
//  ServicesTests
//
//  Created by Mohammed Ibrahim on 2021-10-22.
//

import Foundation
import Apollo

public struct AuctionList {
  var auctions: [Auction] = []
}

extension AuctionList: GraphResponse {
  public init?(_ response: GraphQLSelectionSet?) {
    guard let response = response as? AuctionSubscription.Data else { return nil }
    self.auctions = response.auctions.compactMap { Auction($0) }
  }
}
