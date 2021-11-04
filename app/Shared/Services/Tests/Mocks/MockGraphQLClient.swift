//
//  MockGraphQLClient.swift
//  ServicesTests
//
//  Created by Mohammed Ibrahim on 2021-10-25.
//

import Foundation
@testable import Services
import Combine

final class MockGraphQLClient: GraphQLClient {
  var data: Data?
  var error: QueryError?
  
  init(data: Data?) {
    self.data = data
  }
  
  init(error: QueryError?) {
    self.error = error
  }
  
  func fetch<Query, T>(_ query: Query, cachePolicy: CachePolicy) -> AnyPublisher<T, QueryError> where T : Decodable {
    if let data = data {
      do {
        let result = try JSONDecoder().decode(T.self, from: data)
        return Just(result)
          .setFailureType(to: QueryError.self)
          .eraseToAnyPublisher()

      } catch {
        return Fail(error: QueryError.dataCorrupted)
          .eraseToAnyPublisher()
      }
    } else if let error = error {
      return Fail(error: error)
        .eraseToAnyPublisher()
    } else {
      return Fail(error: QueryError.noData)
        .eraseToAnyPublisher()
    }
  }
  
  func subscription<Subscription, T>(_ subscription: Subscription) -> AnyPublisher<T, QueryError> where T : Decodable {
    fatalError("Implementation for \(#function) missing")
  }
}
