//
//  MockSubscription.swift
//  ServicesTests
//
//  Created by Mohammed Ibrahim on 2021-10-22.
//

import Foundation
import Apollo
import Services

class MockSubscription<Subscription: GraphQLSubscription, Response: GraphResponse>: GraphQLSubscriber {
  typealias Subscription = Subscription
  typealias Response = Response
  
  var apolloSubscription: Subscription
  
  init(subscription: Subscription) {
    self.apolloSubscription = subscription
  }
  
  func subscription() -> Subscription {
    apolloSubscription
  }
}
