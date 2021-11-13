//
//  MockGraphQLClient.swift
//  ServicesTests
//
//  Created by Mohammed Ibrahim on 2021-10-25.
//

import Foundation
import Combine
@testable import Services

class MockGraphQLClient: GraphQL {
    
    func fetch<Query, T>(_ query: Query, cachePolicy: CachePolicy) -> AnyPublisher<T, Error> where Query : GraphQLQuery, T : Decodable {
        fatalError("Implementation for \(#function) missing")
    }
    
    func subscription<Subscription, T>(_ subscription: Subscription) -> AnyPublisher<T, Error> where Subscription : GraphQLSubscription, T : Decodable {
        fatalError("Implementation for \(#function) missing")
    }
}
