//
//  AuctionGraphSubscription.swift
//  ServicesTests
//
//  Created by Mohammed Ibrahim on 2021-10-22.
//

import Foundation
import Apollo

public struct AuctionGraphSubscription {
  public init() {}
}

extension AuctionGraphSubscription: GraphQLSubscriber {
  public typealias Subscription = AuctionSubscription
  public typealias Response = NounsList
  
  public func subscription() -> AuctionSubscription {
    AuctionSubscription()
  }
}
