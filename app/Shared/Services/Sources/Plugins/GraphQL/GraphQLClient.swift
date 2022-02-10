//
//  GraphQLClient.swift
//  Services
//
//  Created by Ziad Tamim on 20.10.21.
//

import Foundation
import Combine

/// GraphQL query error. 
enum QueryError: Error {
  
  struct Reason: Equatable {
    /// The error message associated with the line and column number
    let message: String?
    
    /// A list of locations in the requested GraphQL document associated with the error.
    let locations: [Location]?
  }
  
  struct Location: Equatable {
    /// Line on which the error occurred
    let line: Int?
    
    /// The column at which the error occurred
    let column: Int?
  }
  
  /// The response contains no data
  case noData
  
  /// The provided query was partially or completely invalid
  case invalidQuery(reasons: [Reason])
  
  /// No matching client query
  case noMatchingQuery
  
  /// A malformed query prevented a request from being initiate
  case badQuery
  
  /// An indication that the data is corrupted or otherwise invalid.
  case dataCorrupted(error: Error)
}

/// A cache policy that specifies whether results should be fetched
/// from the server or loaded from the local cache.
public enum CachePolicy {
  /// Return data from the cache if available, else fetch results from the server.
  case returnCacheDataElseFetch
  ///  Always fetch results from the server.
  case fetchIgnoringCacheData
  ///  Always fetch results from the server, and don't store these in the cache.
  case fetchIgnoringCacheCompletely
  /// Return data from the cache if available, else return nil.
  case returnCacheDataDontFetch
  /// Return data from the cache if available, and always fetch results from the server.
  case returnCacheDataAndFetch
}

/// `GraphQL`
protocol GraphQL: AnyObject {
  
  /// Fetches a query from the server or from the local cache, depending on
  /// the current contents of the cache and the specified cache policy.
  ///
  /// The publisher will emit events on the **main** thread.
  ///
  /// - Parameters:
  ///   - query: The query to fetch.
  ///   - cachePolicy: A cache policy that specifies whether results should be fetched or loaded from local.
  ///
  /// - Returns: A publisher emitting a `Decodable` type  instance. The publisher will emit on the *main* thread.
  func fetch<Query, T>(_ query: Query, cachePolicy: CachePolicy) async throws -> T where T: Decodable, Query: GraphQLQuery
  
  /// Registers a publisher that publishes state changes.
  ///
  /// The publisher will emit events on the **main** thread.
  ///
  /// - Parameters:
  ///
  /// - Returns: A publisher emitting a `Decodable` type  instance. The publisher will emit on the *main* thread.
  func subscription<Subscription, T>(_ subscription: Subscription) -> AsyncThrowingStream<T, Error> where T: Decodable, Subscription: GraphQLSubscription
}

class GraphQLClient: GraphQL {
  private let networkingClient: NetworkingClient
  
  init(networkingClient: NetworkingClient = URLSessionNetworkClient()) {
    self.networkingClient = networkingClient
  }
  
  func fetch<Query, T>(
    _ query: Query,
    cachePolicy: CachePolicy
  ) async throws -> T where Query: GraphQLQuery, T: Decodable {
    
    guard let url = query.url else {
      throw URLError(.badURL)
    }
    
    let request = NetworkDataRequest(
      url: url,
      httpMethod: .post(contentType: .json),
      httpBody: try query.encode()
    )
    
    let data = try await networkingClient.data(for: request)
    return try JSONDecoder().decode(T.self, from: data)
  }
  
  func subscription<Subscription, T>(
    _ subscription: Subscription
  ) -> AsyncThrowingStream<T, Error> where Subscription: GraphQLSubscription, T: Decodable {
    
    AsyncThrowingStream { [weak self] continuation in
      guard let self = self else {
        return
      }
      
      guard let url = subscription.url else {
        continuation.finish(throwing: URLError(.badURL))
        return
      }
      
      let listener = ShortPolling<T> {
        let request = NetworkDataRequest(
          url: url,
          httpMethod: .post(contentType: .json),
          httpBody: try subscription.encode()
        )
        
        let data = try await self.networkingClient.data(for: request)
        return try JSONDecoder().decode(T.self, from: data)
      }
      
      listener.setEventHandler = { element in
        continuation.yield(element)
      }
      
      continuation.onTermination = { @Sendable _  in
        listener.stopPolling()
      }
      
      listener.startPolling()
    }
  }
}
