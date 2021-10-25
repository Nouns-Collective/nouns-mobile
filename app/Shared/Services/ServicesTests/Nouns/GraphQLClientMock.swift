//
//  GraphQLMock.swift
//  ServicesTests
//
//  Created by Ziad Tamim on 21.10.21.
//

import Foundation
import Combine
@testable import Services

protocol MockGraphQLResponder {
    static func respond() throws -> Data
}

class MockGraphQLClient<Responder: MockGraphQLResponder>: GraphQLClient {
  func fetch<Query, T>(_ query: Query, cachePolicy: CachePolicy) -> AnyPublisher<T, QueryError> where T : Decodable {
    do {
      let data = try Responder.respond()
      let result = try JSONDecoder().decode(T.self, from: data)
      return Just(result)
        .setFailureType(to: QueryError.self)
        .eraseToAnyPublisher()

    } catch {
      return Fail(error: QueryError.noData)
        .eraseToAnyPublisher()
    }
  }
  
  func subscription<Subscription, T>(_ subscription: Subscription) -> AnyPublisher<T, QueryError> where T : Decodable {
    fatalError("You need to implement \(#function) in your mock.")
  }
}
