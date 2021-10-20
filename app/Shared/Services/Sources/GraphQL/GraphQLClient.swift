//
//  GraphQLClient.swift
//  Services
//
//  Created by Ziad Tamim on 20.10.21.
//

import Foundation
import Combine
import Apollo
import ApolloWebSocket

/// GraphQL query error.
public enum QueryError: Error {
  
  public struct Reason {
    
    /// The error message associated with the line and column number
    public let message: String?
    
    /// A list of locations in the requested GraphQL document associated with the error.
    public let locations: [Location]?
  }
  
  public struct Location {
    /// Line on which the error occurred
    public let line: Int?
    
    /// The column at which the error occurred
    public let column: Int?
  }
  
  /// The response contains no data
  case noData
  
  /// The provided query was partially or completely invalid
  case invalidQuery(reasons: [Reason])
  
  /// A non-HTTPURLResponse was received
  case request(error: Error?)
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
  
  func policy() -> Apollo.CachePolicy {
    switch self {
    case .returnCacheDataElseFetch:
      return .returnCacheDataElseFetch
    case .fetchIgnoringCacheData:
      return .fetchIgnoringCacheData
    case .fetchIgnoringCacheCompletely:
      return .fetchIgnoringCacheCompletely
    case .returnCacheDataDontFetch:
      return .returnCacheDataDontFetch
    case .returnCacheDataAndFetch:
      return .returnCacheDataAndFetch
    }
  }
}

/// GraphQLQuerier protocol will essentially let us write
/// various “queries” for different GraphQL implementations.
public protocol GraphQLQuerier {
  associatedtype ApolloQuery: GraphQLQuery
  func query() -> ApolloQuery
}
public protocol GraphQLClient {
  
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
  func fetch<T: Decodable, Query: GraphQLQuerier>(_ query: Query, cachePolicy: CachePolicy) -> AnyPublisher<T, QueryError>
  
  /// Registers a publisher that publishes state changes
  ///
  /// The publisher will emit events on the **main** thread.
  ///
  /// - Parameters:
  ///
  /// - Returns: A publisher emitting a `Decodable` type  instance. The publisher will emit on the *main* thread.
  func subscription<T: Decodable>() -> AnyPublisher<T, QueryError>
}

public class ApolloGraphQLClient: GraphQLClient {
  private let apolloClient: ApolloClient
  
  public init(apolloClient: ApolloClient) {
    self.apolloClient = apolloClient
  }
  
  public func fetch<T, Query>(_ query: Query, cachePolicy: CachePolicy) -> AnyPublisher<T, QueryError> where T : Decodable, Query : GraphQLQuerier {
    let apolloQuery = query.query()
    let subject = PassthroughSubject<T, QueryError>()

    var cancellable: Apollo.Cancellable?

    cancellable = self.apolloClient.fetch(query: apolloQuery, cachePolicy: cachePolicy.policy()) { result in
      if let errors = try? result.get().errors {
        subject.send(completion: .failure(QueryError.noData))
        return
      }

      do {
        let graphResult = try result.get()
        guard let data = graphResult.data else {
          subject.send(completion: .failure(QueryError.noData))
          return
        }
        subject.send(data)

        if graphResult.source == .server {
          subject.send(completion: .finished)
        }
      } catch let error {
        subject.send(completion: .failure(QueryError.request(error: error)))
      }
    }

    return subject.handleEvents(receiveCancel: {
      cancellable?.cancel()
    }).upstream
      .eraseToAnyPublisher()
  }
  
  public func subscription<T>() -> AnyPublisher<T, QueryError> where T : Decodable {
    fatalError("You need to implement \(#function) to support Apollo.")
  }
}
