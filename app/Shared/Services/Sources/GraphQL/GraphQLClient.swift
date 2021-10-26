//
//  GraphQLClient.swift
//  Services
//
//  Created by Ziad Tamim on 20.10.21.
//

import Foundation
import Combine

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
  
  /// A malformed query prevented a request from being initiate
  case badQuery
  
  /// An indication that the data is corrupted or otherwise invalid.
  case dataCorrupted
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
  func fetch<Query, T>(_ query: Query, cachePolicy: CachePolicy) -> AnyPublisher<T, QueryError> where T: Decodable
  
  /// Registers a publisher that publishes state changes.
  ///
  /// The publisher will emit events on the **main** thread.
  ///
  /// - Parameters:
  ///
  /// - Returns: A publisher emitting a `Decodable` type  instance. The publisher will emit on the *main* thread.
  func subscription<Subscription, T>(_ subscription: Subscription) -> AnyPublisher<T, QueryError> where T: Decodable
}

public class GraphQL: GraphQLClient {
  private let networkingClient: NetworkingClient
  
  public init(networkingClient: NetworkingClient) {
    self.networkingClient = networkingClient
  }
  
  public func fetch<Query, T>(_ query: Query, cachePolicy: CachePolicy) -> AnyPublisher<T, QueryError> where T : Decodable {
    guard let query = query as? GraphQLQuery else {
      return Fail(error: .badQuery).eraseToAnyPublisher()
    }
        
    let operation = GraphQLOperation(query: query)
    do {
      let request = NetworkDataRequest(
        url: operation.url,
        httpMethod: .post(contentType: .json),
        httpBody: try JSONEncoder().encode(operation)
      )
      
      return networkingClient.data(for: request)
        .decode(type: T.self, decoder: JSONDecoder())
        .mapError({ error in
          switch error {
          case is Swift.DecodingError:
            return .dataCorrupted
          case let error as URLError:
            return .request(error: error)
          default:
            return .request(error: error)
          }
        })
        .eraseToAnyPublisher()
    } catch {
      return Fail(error: .request(error: error)).eraseToAnyPublisher()
    }
  }
  
  public func trySomething(data: Data) throws -> Data {
    print(String(data: data, encoding: .utf8))
    throw QueryError.dataCorrupted
  }
  
  public func subscription<Subscription, T>(_ subscription: Subscription) -> AnyPublisher<T, QueryError> where T : Decodable {
    fatalError("Implementaiton for \(#function) missing")
  }
}
