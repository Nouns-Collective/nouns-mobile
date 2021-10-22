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
  public struct Reason: Equatable {
    /// The error message associated with the line and column number
    public let message: String?
    
    /// A list of locations in the requested GraphQL document associated with the error.
    public let locations: [Location]?
  }
  
  public struct Location: Equatable {
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
  
  /// No matching client query
  case noMatchingQuery
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

public protocol GraphQLQuerier {
  associatedtype Query: GraphQLQuery
  associatedtype Response: GraphResponse
  
  /// Factory method for generating an Apollo-ready GraphQL query
  func query() -> Query
}

public protocol GraphQLSubscriber {
  associatedtype Subscription: GraphQLSubscription
  associatedtype Response: GraphResponse
  
  func subscription() -> Subscription
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
  func fetch<Query>(_ query: Query, cachePolicy: CachePolicy) -> AnyPublisher<Query.Response, QueryError> where Query : GraphQLQuerier
  
  /// Registers a publisher that publishes state changes
  ///
  /// The publisher will emit events on the **main** thread.
  ///
  /// - Parameters:
  ///
  /// - Returns: A publisher emitting a `Decodable` type  instance. The publisher will emit on the *main* thread.
  func subscription<Subscription>(_ subscription: Subscription) -> AnyPublisher<Subscription.Response, QueryError> where Subscription : GraphQLSubscriber
}

public class ApolloGraphQLClient: GraphQLClient {
  private let apolloClient: ApolloClientProtocol
  
  public init(apolloClient: ApolloClientProtocol) {
    self.apolloClient = apolloClient
  }
  
  public func fetch<Query>(_ query: Query, cachePolicy: CachePolicy) -> AnyPublisher<Query.Response, QueryError> where Query : GraphQLQuerier {
    let subject = PassthroughSubject<Query.Response, QueryError>()

    var cancellable: Apollo.Cancellable?

    cancellable = self.apolloClient.fetch(query: query.query(),
                                          cachePolicy: cachePolicy.policy(),
                                          contextIdentifier: nil,
                                          queue: .main) { result in
      switch result {
      case .success(let result):
        if let errors = result.errors {
          subject.send(completion: .failure(errors.queryError()))
          return
        }

        guard let data = result.data, let response = Query.Response(data) else {
          subject.send(completion: .failure(QueryError.noData))
          return
        }
        
        subject.send(response)
        
        if result.source == .server {
          subject.send(completion: .finished)
        }
      case .failure(let error):
        subject.send(completion: .failure(QueryError.request(error: error)))
      }
    }

    return subject.handleEvents(receiveCancel: {
      cancellable?.cancel()
    })
    .upstream
    .eraseToAnyPublisher()
  }
  
  public func subscription<Subscription>(_ subscription: Subscription) -> AnyPublisher<Subscription.Response, QueryError> where Subscription : GraphQLSubscriber {
    let subject = PassthroughSubject<Subscription.Response, QueryError>()

    var cancellable: Apollo.Cancellable?

    cancellable = self.apolloClient.subscribe(subscription: subscription.subscription(), queue: .main) { result in
      switch result {
      case .success(let result):
        if let errors = result.errors {
          subject.send(completion: .failure(errors.queryError()))
          return
        }

        guard let data = result.data, let response = Subscription.Response(data) else {
          subject.send(completion: .failure(QueryError.noData))
          return
        }
        
        subject.send(response)
      case .failure(let error):
        subject.send(completion: .failure(QueryError.request(error: error)))
      }
    }

    return subject.handleEvents(receiveCancel: {
      cancellable?.cancel()
    }).upstream
      .eraseToAnyPublisher()
  }
}
